import app/router
import dot_env
import dot_env/env
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load

  let assert Ok(secret_key) = env.get_string("SECRET_KEY")

  let handler = router.handle_request

  let assert Ok(_) =
    handler
    |> wisp_mist.handler(secret_key)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}
