# Sboda


## Database technology
To query for radius of two locations I have decided to use Postgres with  [`POST GIS`](https://postgis.net) since it very advanced and offers all the required features and more.
> To make quering easy I have added [`geo`](https://github.com/bryanjos/geo) and  [`geo_postgis`](https://github.com/bryanjos/geo_postgis).





## Default instructions
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
