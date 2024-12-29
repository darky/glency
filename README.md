# glency

## Deprecated in favor [klubok-gleam](https://github.com/darky/klubok-gleam)

[![Package Version](https://img.shields.io/hexpm/v/glency)](https://hex.pm/packages/glency)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glency/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-a2003e)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Tiny Gleam dependency injection. Make IO functions unit tests friendly.

```sh
gleam add glency
```

```gleam
import glency

type Cat {
  Cat(name: String, age: Int)
}

pub fn main() {
  glency.init_di() // Firstly init DI container on application startup

  {
    // Mock implementation of `fetch_cat`
    use <- glency.with_di(fetch_cat, fn(_cat_id) { Cat("Barsik", 7) })
    fetch_cat(1) // will avoid IO, returns Barsik cat
  }
}

pub fn fetch_cat(cat_id: Int) {
  use <- glency.di(fetch_cat, #(cat_id)) // Make IO function DI friendly
  // Here production IO implementation of function
}
```

Further documentation can be found at <https://hexdocs.pm/glency>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
