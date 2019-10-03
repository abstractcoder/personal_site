defmodule Mix.Tasks.Serve do
  use Mix.Task
  use Plug.Builder
  use Plug.Debugger

  def run(_args) do
    {:ok, _pid} = Plug.Cowboy.http(__MODULE__, [])

    IO.puts("Server is running on http://localhost:4000")

    :timer.sleep(:infinity)
  end

  plug(Plug.Logger)
  plug(Plug.Static, at: "/", from: Path.expand("./static"), only: ["css"])
  plug(__MODULE__.CompileAndServe)

  defmodule CompileAndServe do
    import Plug.Conn

    def init(options) do
      # initialize options
      options
    end

    def call(conn, _opts) do
      {path, bindings} =
        case conn.path_info do
          [] ->
            {"templates/index.html.eex", []}

          ["blog", path] ->
            path = Path.basename(path)
            [file_name] = Path.wildcard("templates/blog/#{path}.{md,html}.eex")
            {file_name, [layout: "blog"]}

          [path] ->
            case Path.wildcard("templates/#{path}.{md,html}.eex") do
              [file_name] ->
                {file_name, []}

              _ ->
                :file_not_found
            end
        end

      html = Static.compile_file(path, bindings)

      conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, html)
    end
  end
end
