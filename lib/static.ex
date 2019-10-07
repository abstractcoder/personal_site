defmodule Static do
  @moduledoc """
  """

  def compile_file(filename, bindings \\ []) do
    contents = File.read!(filename)
    config = Application.get_all_env(:personal_site)

    bindings = 
      config
      |> Keyword.merge(bindings)
      |> Keyword.put(:posts, get_posts())


    parts = String.split(contents, "\n!!!\n")
    name = Path.basename(filename, ".eex")
    mime = MIME.from_path(name)

    do_compile(mime, parts, bindings)
  end

  def do_compile("text/html", parts, bindings) do
    {layout, body, bindings} = get_layout(parts, bindings)
    body = EEx.eval_string(body, assigns: bindings)
    bindings = Keyword.put(bindings, :body, body)
    EEx.eval_file(layout, assigns: bindings)
  end

  def do_compile("text/markdown", parts, bindings) do
    {layout, body, bindings} = get_layout(parts, bindings)

    body =
      EEx.eval_string(body, assigns: bindings)
      |> Earmark.as_html!()

    bindings = Keyword.put(bindings, :body, body)
    EEx.eval_file(layout, assigns: bindings)
  end

  def get_layout(parts, bindings) do
    {body, bindings} =
      case parts do
        [front_matter, body] ->
          fm = parse_front_matter(front_matter)
          {body, Keyword.merge(bindings, fm)}

        [body] ->
          {body, bindings}
      end

    if Keyword.has_key?(bindings, :layout) do
      {"templates/layouts/" <> Keyword.get(bindings, :layout) <> ".html.eex", body, bindings}
    else
      {"templates/layouts/default.html.eex", body, bindings}
    end
  end

  def list_posts() do
    Path.wildcard("./templates/blog/*.{html,md}.eex")
  end

  def get_posts() do
    list_posts()
    |> Enum.map(fn(post) ->
      content = File.read!(post)
      %Post{
        slug: post |> Path.rootname() |> Path.rootname() |> Path.basename(),
        path: post,
        bindings: get_front_matter(content)
      }
    end)
  end

  def get_front_matter(content) do
    [fm | _ ] = String.split(content, "\n!!!\n")
    parse_front_matter(fm)
  end

  def parse_front_matter(string) do
    string
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(&(String.trim(&1) != ""))
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(":")
      |> to_kw()
    end)
    |> Enum.filter(&(&1 != nil))
  end

  def to_kw([key, val]) do
    key = String.to_atom(String.trim(key))
    val = String.trim(val)
    {key, val}
  end

  def to_kw(bad) do
    IO.warn("#{bad} is not a valid front matter value.\n Format expected is key: val")
    nil
  end
end
