defmodule SbodaWeb.PromocodeView do
  use SbodaWeb, :view

  alias __MODULE__

  def render("index.json", %{promocodes: promos}) do
      %{ data: render_many(promos, PromocodeView, "promocode.json", as: :promocode)}
  end

  def render("create.json", %{promocode: promo}) do
    %{ data: render_one(promo, PromocodeView, "promocode.json", as: :promocode)}
  end

  def render("active.json", %{promocodes: promos}) do
      %{ data: render_many(promos, PromocodeView, "promocode.json", as: :promocode)}
  end

  def render("title_config.json", %{promocode: promo}) do
      %{ data: render_one(promo, PromocodeView, "promocode.json", as: :promocode)}
  end

  def render("promocode.json", %{promocode: promo}) do
    %Geo.Point{coordinates: {lgt, lat}} =  promo.point

      %{
          id: promo.id,
          title: promo.title,
          active: promo.active,
          distance: promo.distance,
          worth: Sboda.Money.to_string(promo.worth),
          location: %{
              latitude: lat,
              longitude: lgt
          },
          expire_date: NaiveDateTime.to_string(promo.expir),
          meta: %{
            inserted_at: NaiveDateTime.to_string(promo.inserted_at),
            updated_at: NaiveDateTime.to_string(promo.updated_at)
          }
      }
  end
end
