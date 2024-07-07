import carpenter/table
import gleaf
import gleam/dict
import gleam/list
import gluple/reflect

@external(javascript, "./glency_ffi.mjs", "stub")
pub fn init_di() -> Nil {
  let assert Ok(set) =
    table.build("glency")
    |> table.privacy(table.Public)
    |> table.write_concurrency(table.AutoWriteConcurrency)
    |> table.read_concurrency(True)
    |> table.decentralized_counters(True)
    |> table.compression(False)
    |> table.set
  table.insert(set, [#("glency", dict.new())])
}

@external(javascript, "./glency_ffi.mjs", "di")
pub fn di(key: String, args: tuple, cb: fn() -> resp) -> resp {
  let assert Ok(set) = table.ref("glency")
  let assert Ok(#(_, cache)) = table.lookup(set, "glency") |> list.first
  case dict.get(cache, key) {
    Ok(mock) -> {
      let assert Ok(args) = args |> reflect.tuple_to_list
      args |> gleaf.apply(mock)
    }
    Error(Nil) -> cb()
  }
}

@external(javascript, "./glency_ffi.mjs", "withDi")
pub fn with_di(key: String, mock: mock, cb: fn() -> resp) -> Nil {
  let assert Ok(set) = table.ref("glency")
  let assert Ok(#(_, cache)) = table.lookup(set, "glency") |> list.first
  let cache = dict.insert(cache, key, mock)
  table.insert(set, [#("glency", cache)])
  cb()
  table.insert(set, [#("glency", dict.new())])
}
