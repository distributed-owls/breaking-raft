defmodule BreakingRaft.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/status" do
    send_resp(conn, 200, "ok")
  end

  get "/leader" do
    send_resp(conn, 200, Jason.encode!(BreakingRaft.AtomicBroadcast.leader()))
  end

  post "/configuration" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    parsed_body = Jason.decode!(body)
    {:ok, _} = BreakingRaft.AtomicBroadcast.configure(parsed_body)
    send_resp(conn, 200, "parsed")
  end
end
