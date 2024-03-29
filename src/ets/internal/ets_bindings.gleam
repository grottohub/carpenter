import gleam/erlang/atom

pub external fn all() -> Nil =
  "ets" "all"

pub external fn drop(table: atom.Atom) -> Nil =
  "ets" "delete"

pub external fn delete_key(table: atom.Atom, key: k) -> Nil =
  "ets" "delete"

pub external fn delete_all_objects(table: atom.Atom) -> Nil =
  "ets" "delete_all_objects"

/// TODO: Check if should be v or #(k,v)
pub external fn delete_object(table: atom.Atom, object: v) -> Nil =
  "ets" "delete_object"

pub external fn insert(table: atom.Atom, tuple: #(k, v)) -> Nil =
  "ets" "insert"

pub external fn lookup(table: atom.Atom, key: k) -> List(#(k, v)) =
  "ets" "lookup"

pub external fn give_away(table: atom.Atom, pid: pid, gift_data: any) -> Nil =
  "ets" "give_away"
