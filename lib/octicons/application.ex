defmodule Octicons.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Octicons.Storage, [])
    ]

    opts = [strategy: :one_for_one, name: Octicons.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
