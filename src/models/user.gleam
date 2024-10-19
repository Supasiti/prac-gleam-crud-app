import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/option.{type Option, None}
import gleam/string_builder.{type StringBuilder}

pub type User {
  User(name: String, email: String, id: Option(Int), balance: Float)
}

pub fn from_json(json: Dynamic) -> Result(User, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode4(
      User,
      dynamic.field("name", dynamic.string),
      dynamic.field("email", dynamic.string),
      fn(_x) { Ok(None) },
      dynamic.field("balance", dynamic.float),
    )
  decoder(json)
}

pub fn to_json(user: User) -> StringBuilder {
  let object =
    json.object([
      #("name", json.string(user.name)),
      #("email", json.string(user.email)),
      #("id", json.nullable(user.id, json.int)),
      #("balance", json.float(user.balance)),
    ])
  json.to_string_builder(object)
}
