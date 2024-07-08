import gleeunit
import gleeunit/should
import glency

pub fn main() {
  glency.init_di()
  gleeunit.main()
}

pub fn without_di_test() {
  increment(1)
  |> should.equal(2)
}

pub fn with_di_test() {
  use <- glency.with_di(increment, fn(n) { n + 2 })
  increment(1)
  |> should.equal(3)
}

pub fn with_multiple_di_test() {
  use <- glency.with_di(increment, fn(n) { n + 2 })
  use <- glency.with_di(decrement, fn(n, _) { n - 3 })
  1
  |> increment
  |> decrement(1)
  |> should.equal(0)
}

pub fn all_with_di_cleaned_test() {
  1
  |> increment
  |> decrement(1)
  |> should.equal(1)
}

fn increment(n) {
  use <- glency.di(increment, #(n))
  n + 1
}

fn decrement(n, delta) {
  use <- glency.di(decrement, #(n, delta))
  n - delta
}
