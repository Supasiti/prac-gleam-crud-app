import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/string_builder.{type StringBuilder}


pub type CreateUserParams {
  CreateUserParams(name: String, email: String, balance: Float)
}

pub fn parse_create_params(json: Dynamic) -> Result(CreateUserParams, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode3(
        CreateUserParams,
        dynamic.field("name", dynamic.string),
        dynamic.field("email", dynamic.string),
        dynamic.field("balance", dynamic.float),
        )
    decoder(json)
}

pub type User {
  User(name: String, email: String, id: Int, balance: Float)
}


pub fn to_json(user: User) -> StringBuilder {
  let object =
    json.object([
      #("name", json.string(user.name)),
      #("email", json.string(user.email)),
      #("id", json.int(user.id)),
      #("balance", json.float(user.balance)),
    ])
  json.to_string_builder(object)
}
