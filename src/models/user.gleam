import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/string_builder.{type StringBuilder}
import decode

pub type CreateUserParams {
  CreateUserParams(name: String, email: String, balance: Float)
}

pub fn parse_create_params(
  json: Dynamic,
) -> Result(CreateUserParams, List(dynamic.DecodeError)) {
  decode.into({
    use name <- decode.parameter
    use email <- decode.parameter
    use balance <- decode.parameter
    CreateUserParams(name: name, email: email, balance: balance)
  })
  |> decode.field("name", decode.string)
  |> decode.field("email", decode.string)
  |> decode.field("balance", decode.float)
  |> decode.from(json)
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
