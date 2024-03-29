# desk

[![Package Version](https://img.shields.io/hexpm/v/desk)](https://hex.pm/packages/desk)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/desk/)

Bindings for Erlang's [ETS tables](https://www.erlang.org/doc/man/ets.html). Forked and updated from [gts](https://github.com/Lunarmagpie/gts). 

If you aren't familiar with ETS tables, [this](https://elixirschool.com/en/lessons/storage/ets) is a good introduction.


## Quick start

```gleam
import gleam/io
import ets/builder
import ets/table/set

pub fn main() {
  let set: set.Set(String, String) =
    builder.new("table_name")
    |> builder.set()

  set
  |> set.insert("hello", "world")

  set
  |> set.lookup("hello")
  |> set.debug
}
```

## Installation

This package is available on hex:

```sh
gleam add desk
```

Its documentation can be found at <https://hexdocs.pm/desk>.
