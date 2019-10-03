defmodule Static.MixProject do
  use Mix.Project

  def project do
    [
      app: :static,
      version: "0.1.0",
      elixir: "~> 1.9",
      deps: deps()
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:earmark, "~> 1.3"}
    ]
  end
end
