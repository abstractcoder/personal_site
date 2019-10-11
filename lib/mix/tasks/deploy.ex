defmodule Mix.Tasks.Deploy do
  use Mix.Task

  def run(_args) do
    File.rm_rf!("_deploy")
    File.mkdir!("_deploy")
    IO.puts("Cleaned _deploy dir")

    templates = Path.wildcard("./templates/*.{html,md}.eex")
    posts = Path.wildcard("./templates/blog/*.{html,md}.eex")
    files = templates ++ posts

    IO.puts("Compiling files...")

    for file <- files do
      doc = Static.compile_file(file)

      file_name =
        file
        # Remove both extensions
        |> Path.rootname(".md.eex")
        |> Path.rootname(".html.eex")
        # drop /templates
        |> Path.split()
        |> tl()
        |> Path.join()

      # Make Folders
      file_name
      |> Path.split()
      |> Enum.drop(-1)
      |> Enum.map(fn path ->
        File.mkdir_p!(Path.join(["_deploy", path]))
      end)

      final_name = "_deploy/" <> file_name <> ".html"
      File.write!(final_name, doc)
      IO.puts("#{file} -> #{final_name}")
    end

    File.cp_r!("./static", "_deploy/static")
    IO.puts("Copied ./static to _deploy/static")

    if System.find_executable("cleancss") do
      Path.wildcard("_deploy/**/*.css")
      |> Enum.map(fn path ->
        IO.puts("Optimizing css for #{path}")
        System.cmd("cleancss", ["-o", path, path])
      end)
    else
      IO.warn("Cleancss is not installed, css won't be optimized")
    end
  end
end
