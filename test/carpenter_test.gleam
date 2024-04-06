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
  |> table.insert([#("hello", "world")])
  t
  |> table.lookup("hello")
  |> should.equal([#("hello", "world")])
}

pub fn set_delete_test() {
  let t =
    table.build("delete_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert([#(1, 2)])
  t
  |> table.delete(1)
  t
  |> table.lookup(1)
  |> should.equal([])
}

pub fn set_delete_all_test() {
  let t =
    table.build("delete_all_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert([#(1, 2), #(2, 3)])
  t
  |> table.delete_all

  t
  |> table.lookup(1)
  |> should.equal([])

  t
  |> table.lookup(2)
  |> should.equal([])
}

pub fn set_delete_object_test() {
  let t =
    table.build("delete_obj_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert([#(1, 2)])
  t
  |> table.delete_object(#(1, 2))
  t
  |> table.contains(1)
  |> should.be_false
}

pub fn ordered_set_test() {
  let t =
    table.build("ordered_set_test")
    |> table.ordered_set
    |> should.be_ok

  t
  |> table.insert([#(1, 2), #(2, 3)])
  t
  |> table.lookup(1)
  |> should.equal([#(1, 2)])
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

pub fn contains_test() {
  let t =
    table.build("contains_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert([#(1, 2)])

  t
  |> table.contains(1)
  |> should.be_true
  t
  |> table.contains(2)
  |> should.be_false
}

pub fn ref_test() {
  let t =
    table.ref("contains_test")
    |> should.be_ok

  t
  |> table.contains(1)
  |> should.be_true
}

pub fn take_test() {
  let t =
    table.build("take_test")
    |> table.set
    |> should.be_ok

  t
  |> table.insert([#(1, 2)])
  t
  |> table.contains(1)
  |> should.be_true
  t
  |> table.take(1)
  |> should.equal([#(1, 2)])
  t
  |> table.contains(1)
  |> should.be_false
}
