import ets/table

pub type Set(k, v) {
  Set(table: table.Table(k, v))
}
