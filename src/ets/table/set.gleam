import ets/table
import ets/internal/ets_bindings
import ets/internal/table_type/set

pub type Set(k, v) =
  set.Set(k, v)

/// Return the table for this set object.
pub fn table(set: Set(k, v)) -> table.Table(k, v) {
  set.table
}

/// Insert a value into the ets table.
pub fn insert(set: Set(k, v), key: k, value: v) -> Set(k, v) {
  ets_bindings.insert(
    set.table
    |> table.name(),
    #(key, value),
  )
  set
}

/// Retrieve a value from the ets table. Return an error if the value could
/// not be found.
pub fn lookup(set: Set(k, v), key: k) -> Result(v, Nil) {
  case
    ets_bindings.lookup(
      set.table
      |> table.name(),
      key,
    )
  {
    [] -> Error(Nil)
    [value, ..] -> Ok(value.1)
  }
}

/// Delete all objects with key `key` from the table.
pub fn delete(set: Set(k, v), key: k) -> Set(k, v) {
  ets_bindings.delete_key(
    set.table
    |> table.name(),
    key,
  )
  set
}
