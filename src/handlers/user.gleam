import gleam/int
import gleam/result
import models/user
import wisp.{type Request, type Response}

pub fn create_one(req: Request) -> Response {
  use json <- wisp.require_json(req)

  let result_user = {
    use create_user_params <- result.try(user.parse_create_params(json))

    // TODO: save to database here 

    user.User(
      name: create_user_params.name,
      email: create_user_params.email,
      balance: create_user_params.balance,
      id: 1,
    )
    |> user.to_json
    |> Ok
  }

  case result_user {
    Ok(json) -> wisp.json_response(json, 201)
    Error(_) -> wisp.bad_request()
  }
}

pub fn one(id: Int) -> Response {
  user.User(name: "Bob", email: "bob@email.com", id: id, balance: 234.1)
  |> user.to_json
  |> wisp.json_response(200)
}

pub fn validate_id(id: String, next: fn(Int) -> Response) -> Response {
  case int.base_parse(id, 10) {
    Ok(id) -> next(id)
    Error(_) -> wisp.bad_request()
  }
}
