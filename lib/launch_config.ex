defmodule LaunchConfig do
  use Boundary

  use Provider,
    source: Provider.SystemEnv,
    params: [
      {:release_level, dev: "dev"},

      # database
      {:database_url, dev: dev_database_url()},
      {:database_pool_size, type: :integer, default: 10},
      {:database_ssl, type: :boolean, default: false},

      # endpoint
      {:host, dev: "localhost"},
      {:port, type: :integer, default: 4000, test: 4002},
      {:secret_key_base, dev: "8H5R0q+dNsxvOAprf2W85yyk55MsyvBEwBhqg6tVvVNWp9TP7HC9gDl3K09dkx8y"}
    ]

  if Mix.env() in ~w/dev test/a do
    defp dev_database_url do
      database_host = System.get_env("PGHOST", "localhost")
      database_name = if ci?(), do: "launch_test", else: "launch_#{unquote(Mix.env())}"
      "postgresql://postgres:postgres@#{database_host}/#{database_name}"
    end

    defp ci?, do: System.get_env("CI") == "true"
  end
end
