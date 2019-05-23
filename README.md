# Sboda

NOTE: YOU MUST INSTALL POSTGIS IN ORDER TO BE ABLE TO RUN THE PROJECT (Instructions are provided)

### SETUP INSTRUCTIONS
1. Make sure you have a running Postgres Database
2. Download https://postgis.net, this will give postgres ability to work with (geometry, geography, raster, etc).

    [`use this tutorial`](https://www.bostongis.com/PrinterFriendly.aspx?content_name=postgis_tut01)

  3. Install dependencies with mix deps.get
  4. make sure the postgress password and username is correct inside config/dev.exs and config/test.exs
  5. Create and migrate your database with mix ecto.setup
  6. Install Node.js dependencies with cd assets && npm install
  7.  Run seed migration `mix run priv/repo/seeds.exs`
  8. Start Phoenix endpoint with mix phx.server

>RUNNING Test
``` bash
user@user:~$ iex -S mix

iex> mix test
```

#### TASKS
- [x] Generation of new promo codes for events
    > Function: Sboda.Marketing.create_promocode(attr)

    ```elixir
    iex > param = %{
      title: "SAFE_BODA_EVENT",
      lat: 43.0387105,
      logt: -87.9074701,
      expir_str: "2019-07-01 23:00:07",
      worth_str: "250.00",
      distance: 400.3,
      currency: "KES",
      active: true
    }

    iex> Sboda.Marketing.create_promocode(param)
      {:ok, %Promocode{}} | {:error, %Ecto.Changeset{}}
    ```
    > Test: tested in Sboda.MarketingTest

- [x] The promo code is worth a specific amount of ride
    > Promocode has a field of type money that is accepting UGX or KES currency


- [x] The promo code can expire
  > Promocode has expir field which is a NaiveDateTime, that can be used to check if the promo is expired

- [x] Can be deactivated
  > Promocode has active field, which can be set to false hence deactivating the code.

- [x] Return active promo codes
  > For this task am returning promocodes that have active field set to true and expir date is bigger or equal to date now.

  >Function: Sboda.Marketing.get_active_promocodes()

  ```elixir
  iex> Sboda.Marketing.get_active_promocodes()
    [%Promocode{}] | []
  ```
  >Test is done inside: Sboda.MarketingTest



- [x] Return all promo codes
  > Here am returning all promocodes from the database

  >Function: Sboda.Marketing.get_all_promocodes()

  ```elixir
  iex> Sboda.Marketing.get_all_promocodes()
    [%Promocode{}] | []
  ```
  >Test is done inside: Sboda.MarketingTest

- [x] Only valid when user’s pickup or destination is within x radius of the event venue
     Here I was checking if destination or origin is within the radius of the promocode applied if yes. use it, else: return an error

    > Functions

     1. **Sboda.Ride.ValidateRequest**
         Am using embedded_schema to validate if origin or destination is within the promo/event radius

      2. **Marketing.location_within_event(promocode, dest_point)**

         Am using [`Geocalc`](https://github.com/yltsrc/geocalc) libray to check if the detination.origin is within the promocode radius.
  > Test are include

- [x] The promo code radius should be configurable
    <br>
    >  For this I have created a function that when provided with the title of the promocode and the radius it changes the radius.

    ```elixir
    iex> Sboda.Marketing.change_radius(title, radius)
       {:ok, %Promocode{}} | {:changeset_error, %Ecto.Changeset{}} | {:error, term()}
    ```

    > Test are include

- [x] To test the validity of the promo code, expose an endpoint that accept origin, destination,
the promo code. The api should return the promo code details and a polyline using the
destination and origin if promo code is valid and an error otherwise.

> For this task I created  <br>
`post("/ride/request", RideController, :request)`
 <br>

 Endpoint which takes in origin, destination and the promocode title.
`@params`
 ```elixir
 {
	"origin": {
		"latitude": 43.0387105,
		"longitude": -87.9074701
	},
	"destination": {
		"latitude": 43.035253,
		"longitude": -87.9033059
	},
	"promocode": "SAFE_BODA_EVENT"
}

>> POST_URL: http://localhost:4000/api/v1/ride/request
 ```
 To generate the polyline I created a simple **DirectionApi** wrapper to get the polystring and decode into a list of coordinates.

### Extras
- [x] since am using Postgis I am able to list all active promocodes withing my origin or point.
- [x] Created endpoints for getting all promocodes, updating radius and getting active promocodes. 

`Sboda.Marketing.get_active_promocodes_within/2`
`
