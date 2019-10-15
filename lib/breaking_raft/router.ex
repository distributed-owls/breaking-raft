defmodule BreakingRaft.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/status" do
    send_resp(conn, 200, "ok")
  end

  get "/configuration" do
    send_resp(conn, 200, Jason.encode!([Node.self() | Node.list()]))
  end

  post "/configuration" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    parsed_body = Jason.decode!(body)
    {:ok, _} = BreakingRaft.RealWorld.AtomicBroadcast.configure(parsed_body)
    send_resp(conn, 200, "parsed")
  end

end
