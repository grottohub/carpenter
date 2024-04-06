import gleam/dynamic
import gleam/erlang/atom

@external(erlang, "ets", "all")
pub fn all() -> Nil

@external(erlang, "ets", "delete")
pub fn drop(table: atom.Atom) -> Nil

@external(erlang, "ets", "delete")
pub fn delete_key(table: atom.Atom, key: k) -> Nil

@external(erlang, "ets", "delete_all_objects")
pub fn delete_all_objects(table: atom.Atom) -> Nil

@external(erlang, "ets", "delete_object")
pub fn delete_object(table: atom.Atom, object: #(k, v)) -> Nil

@external(erlang, "ets", "insert")
pub fn insert(table: atom.Atom, tuple: List(#(k, v))) -> Nil

@external(erlang, "ets", "lookup")
pub fn lookup(table: atom.Atom, key: k) -> List(#(k, v))

@external(erlang, "ets", "give_way")
pub fn give_away(table: atom.Atom, pid: pid, gift_data: any) -> Nil

@external(erlang, "carpenter", "new_table")
pub fn new_table(
  name: atom.Atom,
  props: List(dynamic.Dynamic),
) -> Result(atom.Atom, Nil)
