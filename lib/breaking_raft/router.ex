defmodule BreakingRaft.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/status", do: send_resp(conn, 200, "ok"))
  get("/configuration", do: send_resp(conn, 200, ~s([1, 2, 3])))
end
