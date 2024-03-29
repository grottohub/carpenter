import gleam/erlang/atom

@external(erlang, "ets", "all")
pub fn all() -> Nil

@external(erlang, "ets", "delete")
pub fn drop(table: atom.Atom) -> Nil

@external(erlang, "ets", "delete")
pub fn delete_key(table: atom.Atom, key: k) -> Nil

@external(erlang, "ets", "delete_all_objects")
pub fn delete_all_objects(table: atom.Atom) -> Nil

/// TODO: Check if should be v or #(k,v)
@external(erlang, "ets", "delete_object")
pub fn delete_object(table: atom.Atom, object: v) -> Nil

@external(erlang, "ets", "insert")
pub fn insert(table: atom.Atom, tuple: #(k, v)) -> Nil

@external(erlang, "ets", "lookup")
pub fn lookup(table: atom.Atom, key: k) -> List(#(k, v))

@external(erlang, "ets", "give_way")
pub fn give_away(table: atom.Atom, pid: pid, gift_data: any) -> Nil
