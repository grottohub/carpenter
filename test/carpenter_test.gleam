import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import carpenter/table

pub fn main() {
  gleeunit.main()
}

pub fn set_insert_test() {
  let t =
    table.build("set_insert_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert("hello", "world")
  |> table.lookup("hello")
  |> should.equal(Some([#("hello", "world")]))
}

pub fn set_delete_test() {
  let t =
    table.build("delete_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert(1, 2)
  |> table.delete(1)
  |> table.lookup(1)
  |> should.equal(None)
}

pub fn set_delete_all_test() {
  let t =
    table.build("delete_all_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert(1, 2)
  |> table.insert(2, 3)
  |> table.delete_all

  t
  |> table.lookup(1)
  |> should.equal(None)

  t
  |> table.lookup(2)
  |> should.equal(None)
}

pub fn ordered_set_test() {
  let t =
    table.build("ordered_set_test")
    |> table.ordered_set
    |> should.be_ok

  t
  |> table.insert(1, 2)
  |> table.insert(2, 3)
  |> table.lookup(1)
  |> should.equal(Some([#(1, 2)]))
}

pub fn drop_test() {
  let t =
    table.build("drop_test")
    |> table.set
    |> should.be_ok

  table.build("drop_test")
  |> table.set
  |> should.be_error

  t
  |> table.drop

  table.build("drop_test")
  |> table.set
  |> should.be_ok
}
