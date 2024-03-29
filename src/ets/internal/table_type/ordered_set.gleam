import ets/table

pub type OrderedSet(k, v) {
  OrderedSet(table: table.Table(k, v))
}
