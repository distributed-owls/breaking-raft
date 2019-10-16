defmodule BreakingRaft.Router do
  use Plug.Router
  alias BreakingRaft.AtomicBroadcast

  plug(:match)
  plug(:dispatch)

  get "/status" do
    send_resp(conn, 200, "ok")
  end

  get "/leader" do
    send_resp(conn, 200, Jason.encode!(AtomicBroadcast.leader()))
  end

  post "/configuration" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    parsed_body = Jason.decode!(body)
    {:ok, _} = AtomicBroadcast.configure(parsed_body)
    send_resp(conn, 200, "parsed")
  end

  post "/broadcast" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    # parsed_body = Jason.decode!(body)
    {:ok, _} = AtomicBroadcast.broadcast(body)
    send_resp(conn, 200, "JKM KRUL")
  end

  get "/delivered_messages" do
    {:ok, messages} = AtomicBroadcast.delivered_messages()
    send_resp(conn, 200, Jason.encode!(messages))
  end
end
