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

      dir_name =
        file
        # Remove both extensions
        |> Path.rootname(".md.eex")
        |> Path.rootname(".html.eex")
        # drop /templates
        |> Path.split()
        |> tl()
        |> Path.join()

      # Root Page should exist in root directory
      dir_name =
        case dir_name do
          "index" -> ""
          _ -> dir_name
        end

      # Make Folder
      final_dir_name = Path.join(["_deploy", dir_name])
      File.mkdir_p!(final_dir_name)

      # Make File
      final_name = Path.join([final_dir_name, "index.html"])
      File.write!(final_name, doc)
      IO.puts("#{file} -> #{final_name}")
    end

    File.cp_r!("./static", "_deploy/static")
    IO.puts("Copied ./static to _deploy/static")
  end
end
