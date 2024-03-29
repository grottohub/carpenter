import gleam/option.{type Option, None, Some}
import carpenter/table
import carpenter/internal/ets_bindings
import carpenter/internal/table_type/ordered_set

pub type OrderedSet(k, v) =
  ordered_set.OrderedSet(k, v)

/// Return the table for this set object.
pub fn table(set: OrderedSet(k, v)) -> table.Table(k, v) {
  set
  |> table()
}

/// Insert a value into the ets table.
pub fn insert(set: OrderedSet(k, v), key: k, value: v) -> OrderedSet(k, v) {
  ets_bindings.insert(
    set.table
      |> table.name(),
    #(key, value),
  )
  set
}

/// Retrieve a value from the ets table. Return an option if the value could
/// not be found.
pub fn lookup(set: OrderedSet(k, v), key: k) -> Option(List(#(k, v))) {
  case
    ets_bindings.lookup(
      set.table
        |> table.name(),
      key,
    )
  {
    [] -> None
    [_, ..] as kv -> Some(kv)
  }
}

/// Delete all objects with key `key` from the table.
pub fn delete(set: OrderedSet(k, v), key: k) -> OrderedSet(k, v) {
  ets_bindings.delete_key(
    set.table
      |> table.name(),
    key,
  )
  set
}
