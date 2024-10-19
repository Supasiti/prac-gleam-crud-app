import app/web
import gleam/http
import handlers/user
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    // This matches /api/..`.
    ["api", ..path] -> api(path, req)

    // This matches all other paths.
    _ -> wisp.not_found()
  }
}

fn api(path: List(String), req: Request) -> Response {
  case path {
    ["users"] -> users(req)
    ["users", id] -> user(req, id)
    _ -> wisp.not_found()
  }
}

fn users(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)

  user.create_one(req)
}

fn user(req: Request, id: String) {
  use <- wisp.require_method(req, http.Get)
  use id <- user.validate_id(id)
  user.one(id)
}
