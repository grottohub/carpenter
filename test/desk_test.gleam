import gleam/option.{Some}
import gleeunit
import gleeunit/should
import ets/builder
import ets/table/set
import ets/table/ordered_set

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn set_insert_test() {
  builder.new("set_insert_test")
  |> builder.set()
  |> set.insert("hello", "world")
  |> set.lookup("hello")
  |> should.equal(Some("world"))
}

pub fn ordered_set_test() {
  builder.new("ordered_set_test")
  |> builder.ordered_set()
  |> ordered_set.insert(1, 2)
  |> ordered_set.insert(2, 3)
  |> ordered_set.lookup(1)
  |> should.equal(Some([#(1, 2)]))
}
