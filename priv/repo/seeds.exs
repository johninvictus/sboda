# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sboda.Repo.insert!(%Sboda.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Sboda.Repo
alias Sboda.Marketing.Promocode

data_test = [
  %{
    title: "SAFE_BODA_EVENT",
    lat: 43.0387105,
    logt: -87.9074701,
    expir_str: "2029-07-01 23:00:07",
    worth_str: "250.00",
    distance: 400.3,
    currency: "KES",
    active: true
  },
  %{
    title: "SAFE_BODA_EVENT_2",
    lat: 43.0372896,
    logt: -87.9082446,
    expir_str: "2019-07-01 23:00:07",
    worth_str: "250.00",
    distance: 400.3,
    currency: "KES",
    active: false
  },
  %{
    title: "SAFE_BODA_EVENT_3",
    lat: 43.035253,
    logt: -87.9091676,
    expir_str: "2018-07-01 23:00:07",
    worth_str: "250.00",
    distance: 400.3,
    currency: "KES",
    active: false
  },
  %{
    title: "SAFE_BODA_EVENT_4",
    lat: 43.0020021,
    logt: -87.9033059,
    expir_str: "2018-07-01 23:00:07",
    worth_str: "250.00",
    distance: 400.3,
    currency: "KES",
    active: true
  }
]

for param <- data_test do
  Repo.get_by(Promocode, title: param.title) ||
    Promocode.changeset(%Promocode{}, param)
    |> Repo.insert!()
end
