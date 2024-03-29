//// Generic operations on every table type.

import gleam/erlang/atom
import gleam/erlang/process
import ets/internal/ets_bindings

pub opaque type Table(k, v) {
  Table(name: atom.Atom)
}

pub fn new(name: atom.Atom) {
  Table(name)
}

pub fn name(table: Table(k, v)) -> atom.Atom {
  table.name
}

/// Deletes the entire table.
pub fn drop(table: Table(k, v)) {
  ets_bindings.drop(table.name)
}

/// Give the table to another process.
pub fn give_away(table: Table(k, v), pid: process.Pid, gift_data: any) -> Nil {
  ets_bindings.give_away(table.name, pid, gift_data)
}
