defmodule Iptools.Mixfile do
  use Mix.Project

  @source_url "https://github.com/freedomben/iptools"
  @version "0.0.6"

  def project do
    [
      app: :iptools_fb,
      version: @version,
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "A set of functions for validating and transforming IPv4 addresses",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def package do
    [
      maintainers: ["Kevin Thompson"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "iptools_fb",
      source_url: @source_url,
      extra_section: [],
      api_reference: false
    ]
  end
end
