import gleeunit
import gleeunit/should
import ets/builder
import ets/table/set
import ets/table/ordered_set

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn test_set_insert() {
  builder.new("test_name")
  |> builder.set()
  |> set.insert("hello", "world")
  |> set.lookup("hello")
  |> should.equal(Ok("world"))
}

pub fn test_ordered_set() {
  builder.new("test_name")
  |> builder.ordered_set()
  |> ordered_set.insert(1, 2)
  |> ordered_set.insert(2, 3)
  |> ordered_set.lookup(1)
  |> should.equal(Ok([#(1, 2)]))
}
