defmodule SbodaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias SbodaWeb.Router.Helpers, as: Routes
      alias SbodaWeb.Support.APICall
      import SbodaWeb.ConnCaseHelper

      # The default endpoint for testing
      @endpoint SbodaWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sboda.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Sboda.Repo, {:shared, self()})
    end

    launch_api()

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def launch_api do
    # set up config for serving
    endpoint_config =
      Application.get_env(:sboda, SbodaWeb.Endpoint)
      |> Keyword.put(:server, true)
    :ok = Application.put_env(:sboda, SbodaWeb.Endpoint, endpoint_config)

    # restart our application with serving enabled
    :ok = Application.stop(:sboda)
    :ok = Application.start(:sboda)
  end
end
