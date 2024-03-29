import gleam/erlang/atom
import gleam/dynamic
import gleam/list
import gleam/option.{None, Option, Some}
import ets/internal/table_type/set as set_i
import ets/table
import ets/table/set
import ets/internal/table_type/ordered_set as ordered_set_i
import ets/table/ordered_set
import ets/config/write_concurrency
import ets/config/privacy

external fn new_table(name: atom.Atom, props: List(dynamic.Dynamic)) -> Nil =
  "ets" "new"

pub type TableBuilder(k, v) {
  TableBuilder(
    name: String,
    privacy: Option(privacy.Privacy),
    write_concurrency: Option(write_concurrency.WriteConcurrency),
    read_concurrency: Option(Bool),
    decentralized_counters: Option(Bool),
    compressed: Bool,
  )
}

pub fn new(name: String) -> TableBuilder(k, v) {
  TableBuilder(
    name: name,
    privacy: None,
    write_concurrency: None,
    read_concurrency: None,
    decentralized_counters: None,
    compressed: False,
  )
}

pub fn privacy(
  builder: TableBuilder(k, v),
  privacy: privacy.Privacy,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, privacy: Some(privacy))
}

pub fn write_concurrency(
  builder: TableBuilder(k, v),
  con: write_concurrency.WriteConcurrency,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, write_concurrency: Some(con))
}

pub fn read_concurrency(
  builder: TableBuilder(k, v),
  con: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, read_concurrency: Some(con))
}

pub fn decentralized_counters(
  builder: TableBuilder(k, v),
  counters: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, decentralized_counters: Some(counters))
}

pub fn compression(
  builder: TableBuilder(k, v),
  compressed: Bool,
) -> TableBuilder(k, v) {
  TableBuilder(..builder, compressed: compressed)
}

fn privacy_prop(prop: privacy.Privacy) -> dynamic.Dynamic {
  case prop {
    privacy.Private -> "private"
    privacy.Protected -> "protected"
    privacy.Public -> "public"
  }
  |> atom.create_from_string
  |> dynamic.from
}

pub fn write_concurrency_prop(
  prop: write_concurrency.WriteConcurrency,
) -> dynamic.Dynamic {
  case prop {
    write_concurrency.True -> "true"
    write_concurrency.False -> "false"
    write_concurrency.Auto -> "auto"
  }
  |> atom.create_from_string
  |> fn(x) { #(atom.create_from_string("write_concurrency"), x) }
  |> dynamic.from
}

pub fn build_table(builder: TableBuilder(k, v), table_type: String) -> atom.Atom {
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

  new_table(
    name,
    props
    |> list.map(dynamic.from),
  )
  name
}

pub fn set(builder: TableBuilder(k, v)) -> set.Set(k, v) {
  let table = build_table(builder, "set")
  set_i.Set(table.new(table))
}

pub fn ordered_set(builder: TableBuilder(k, v)) -> ordered_set.OrderedSet(k, v) {
  let table = build_table(builder, "ordered_set")
  ordered_set_i.OrderedSet(table.new(table))
}
