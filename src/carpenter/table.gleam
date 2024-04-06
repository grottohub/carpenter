import gleam/erlang/atom
import gleam/erlang/process
import gleam/dynamic
import gleam/list
import gleam/option.{type Option, None, Some}
import carpenter/internal/ets_bindings

pub type TableBuilder(k, v) {
  TableBuilder(
    name: String,
    privacy: Option(Privacy),
    write_concurrency: Option(WriteConcurrency),
    read_concurrency: Option(Bool),
    decentralized_counters: Option(Bool),
    compressed: Bool,
  )
}

pub type Privacy {
  Private
  Protected
  Public
}

pub type WriteConcurrency {
  WriteConcurrency
  NoWriteConcurrency
  AutoWriteConcurrency
}

/// Begin building a new table with the given name. Ensure your table names are unique, 
/// otherwise you will encounter a `badarg` failure at runtime when attempting to build it.
pub fn build(name: String) -> TableBuilder(k, v) {
  TableBuilder(
    name: name,
    privacy: None,
    write_concurrency: None,
    read_concurrency: None,
    decentralized_counters: None,
    compressed: False,
  )
}

/// Set the privacy of the table.
/// Acceptable values are `Private`, `Protected`, and `Public`.
pub fn privacy(
  builder: TableBuilder(k, v),
  privacy: Privacy,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, privacy: Some(privacy))
}

/// Set the write_concurrency of the table.
/// Acceptable values are `WriteConcurrency`, `NoWriteConcurrency`, or `AutoWriteConcurrency`.
pub fn write_concurrency(
  builder: TableBuilder(k, v),
  con: WriteConcurrency,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, write_concurrency: Some(con))
}

/// Whether or not the table uses read_concurrency. Acceptable values are `True` or `False.
pub fn read_concurrency(
  builder: TableBuilder(k, v),
  con: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, read_concurrency: Some(con))
}

/// Whether or not the table uses decentralized_counters.
/// Acceptable values are `True` or `False`.
/// 
/// You should probably choose `True` unless you are going to be polling
/// the table for its size and memory usage frequently.
pub fn decentralized_counters(
  builder: TableBuilder(k, v),
  counters: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, decentralized_counters: Some(counters))
}

/// Whether or not the table is compressed.
pub fn compression(
  builder: TableBuilder(k, v),
  compressed: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, compressed: compressed)
}

fn privacy_prop(prop: Privacy) -> dynamic.Dynamic {
  case prop {
    Private -> "private"
    Protected -> "protected"
    Public -> "public"
  }
  |> atom.create_from_string
  |> dynamic.from
}

fn write_concurrency_prop(prop: WriteConcurrency) -> dynamic.Dynamic {
  case prop {
    WriteConcurrency -> "true"
    NoWriteConcurrency -> "false"
    AutoWriteConcurrency -> "auto"
  }
  |> atom.create_from_string
  |> fn(x) { #(atom.create_from_string("write_concurrency"), x) }
  |> dynamic.from
}

fn build_table(
  builder: TableBuilder(k, v),
  table_type: String,
) -> Result(atom.Atom, Nil) {
  let name = atom.create_from_string(builder.name)

  let props =
    [
      atom.create_from_string(table_type),
      atom.create_from_string("named_table"),
    ]
    |> list.map(dynamic.from)

  let props = case builder.privacy {
    Some(x) -> [privacy_prop(x), ..props]
    _ -> props
  }

  let props = case builder.write_concurrency {
    Some(x) -> [write_concurrency_prop(x), ..props]
    _ -> props
  }

  let props = case builder.read_concurrency {
    Some(x) -> [
      #(atom.create_from_string("read_concurrency"), x)
        |> dynamic.from,
      ..props
    ]
    _ -> props
  }

  let props = case builder.compressed {
    True -> [
      atom.create_from_string("compressed")
        |> dynamic.from,
      ..props
    ]
    False -> props
  }

  ets_bindings.new_table(
    name,
    props
      |> list.map(dynamic.from),
  )
}

/// Specify table as a `set`
pub fn set(builder: TableBuilder(k, v)) -> Result(Set(k, v), Nil) {
  case build_table(builder, "set") {
    Ok(t) -> Ok(Set(Table(t)))
    Error(_) -> Error(Nil)
  }
}

/// Specify table as an `ordered_set`
pub fn ordered_set(builder: TableBuilder(k, v)) -> Result(Set(k, v), Nil) {
  case build_table(builder, "ordered_set") {
    Ok(t) -> Ok(Set(Table(t)))
    Error(_) -> Error(Nil)
  }
}

pub type Table(k, v) {
  Table(name: atom.Atom)
}

pub type Set(k, v) {
  Set(table: Table(k, v))
}

/// Insert a list of objects into the set
pub fn insert(set: Set(k, v), objects: List(#(k, v))) -> Nil {
  ets_bindings.insert(set.table.name, objects)
}

/// Insert a list of objects without overwriting any existing keys.
/// 
/// This will not insert ANY object unless ALL keys do not exist.
pub fn insert_new(set: Set(k, v), objects: List(#(k, v))) -> Bool {
  ets_bindings.insert_new(set.table.name, objects)
}

/// Retrieve a list of objects from the table.
pub fn lookup(set: Set(k, v), key: k) -> List(#(k, v)) {
  ets_bindings.lookup(set.table.name, key)
}

/// Delete all objects with key `key` from the table.
pub fn delete(set: Set(k, v), key: k) -> Nil {
  ets_bindings.delete_key(set.table.name, key)
}

/// Delete all objects belonging to a table
pub fn delete_all(set: Set(k, v)) -> Nil {
  ets_bindings.delete_all_objects(set.table.name)
}

/// Delete an exact object from the table
pub fn delete_object(set: Set(k, v), object: #(k, v)) -> Nil {
  ets_bindings.delete_object(set.table.name, object)
}

/// Deletes the entire table.
pub fn drop(set: Set(k, v)) {
  ets_bindings.drop(set.table.name)
}

/// Give the table to another process.
pub fn give_away(set: Set(k, v), pid: process.Pid, gift_data: any) -> Nil {
  ets_bindings.give_away(set.table.name, pid, gift_data)
}

/// Returns a boolean based on the existence of a key within the table
pub fn contains(set: Set(k, v), key: k) -> Bool {
  ets_bindings.member(set.table.name, key)
}

/// Get a reference to an existing table
pub fn ref(name: String) -> Result(Set(k, v), Nil) {
  case atom.from_string(name) {
    Ok(t) -> Ok(Set(Table(t)))
    Error(_) -> Error(Nil)
  }
}

/// Return and remove a list of objects with the given key
pub fn take(set: Set(k, v), key: k) -> List(#(k, v)) {
  ets_bindings.take(set.table.name, key)
}
