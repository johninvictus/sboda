defmodule Sboda.Marketing do
  @moduledoc """
  The Marketing context.
  """

  import Ecto.Query, warn: false
  alias Sboda.Repo

  alias Sboda.Marketing.Promocode


  @doc """
  Creates the promocode when given a Map.

  # Example
    iex> Sboda.Marketing.create_promocode(%{ all data here})
      {:ok, %Sboda.Marketing.Promocode{}}

    iex> Sboda.Marketing.create_promocode(%{ all data here})
       {:error, %Ecto.Changeset{}}
  """

  def create_promocode(attr \\ Map.new()) do
    %Promocode{}
    |> Promocode.changeset(attr)
    |> Repo.insert()
  end

  @doc """
  Returns all promocodes in the database

   ## Example

    iex> Sboda.Marketing.get_all_pomocodes()
  """
  def get_all_pomocodes do
    Promocode |> Repo.all()
  end
end
