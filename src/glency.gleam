import carpenter/table
import gleaf
import gleam/dict
import gleam/list
import gluple/reflect

pub fn init_di() {
  let assert Ok(set) =
    table.build("glency")
    |> table.privacy(table.Public)
    |> table.write_concurrency(table.AutoWriteConcurrency)
    |> table.read_concurrency(True)
    |> table.decentralized_counters(True)
    |> table.compression(False)
    |> table.set

  set
}

pub fn di(key: String, args, cb) {
  let assert Ok(set) = table.ref("glency")
  case table.lookup(set, "glency") |> list.first {
    Ok(#(_, cache)) -> {
      case dict.get(cache, key) {
        Ok(cb) -> {
          let assert Ok(args) = args |> reflect.tuple_to_list
          args |> gleaf.apply(cb)
        }
        Error(Nil) -> cb()
      }
    }
    Error(Nil) -> cb()
  }
}

pub fn with_di(key: String, mock, cb) {
  let assert Ok(set) = table.ref("glency")
  case table.lookup(set, "glency") |> list.first {
    Ok(#(_, cache)) -> {
      let cache = dict.insert(cache, key, mock)
      table.insert(set, [#("glency", cache)])
      set
    }
    Error(Nil) -> {
      table.insert(set, [#("glency", dict.from_list([#(key, mock)]))])
      set
    }
  }

  cb()
  table.delete_all(set)
}
