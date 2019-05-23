# Sboda


### SETUP INSTRUCTIONS
1. Make sure you have a running Postgres Database
2. Install dependencies with mix deps.get
3. make sure the Postgres password and username is correct inside config/dev.exs and config/test.exs
4. Create and migrate your database with mix ecto.setup
5. Install Node.js dependencies with cd assets && npm install
6. Start Phoenix endpoint with mix phx.server


>RUNNING Test

```
user@user:~$ iex -S mix

iex> mix test
```

#### TASKS

-[ X ]- **Generation of new promo codes for events** <br/>

   Function: Sboda.Marketing.create_promocode(attr)

    ```
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
    Test: tested in Sboda.MarketingTest
  <br/>
**-[ X ]- The promo code is worth a specific amount of ride**

<br/>
    Promo code has a field of type money that is accepting UGX or KES currency


**-[ X ]- The promo code can expire**
<br/>

 Promo code has expir field which is a NaiveDateTime, that can be used to check if the promo is expired

**-[ X ]- Can be deactivated**
<br/>

   Promo code has an active field, which can be set to false hence deactivating the code.

**-[ X ]- Return active promo codes**
<br/>

  For this task am returning promo codes that have the active field set to true and expir date is bigger or equal to date now.

  Function: `Sboda.Marketing.get_active_promocodes()`

  ```
  iex> Sboda.Marketing.get_active_promocodes()
    [%Promocode{}] | []
  ```


**-[ X ]- Return all promo codes**
<br/>

  Here am returning all promo codes from the database

  Function: `Sboda.Marketing.get_all_promocodes()`

  ```
  iex> Sboda.Marketing.get_all_promocodes()
    [%Promocode{}] | []
  ```
  Test is done inside: Sboda.MarketingTest

**-[ X ]- Only valid when user’s pickup or destination is within x radius of the event venue**

     Here I was checking if destination or origin is within the radius of the promocode applied if yes. use it, else: return an error
<br/>


  **Functions**

     -  Sboda.Ride.ValidateRequest
         I am using embedded_schema to validate if origin or destination is within the
<promo/event radius

     -  Marketing.location_within_event(promocode, dest_point)
         Am using [Geocalc](https://github.com/yltsrc/geocalc) libray to check if the detination.origin is within the promocode radius.

**-[ X ]- The promo code radius should be configurable**
<br/>

   For this I have created a function that when provided with the title of the promo code and the radius it changes the radius.

    ```
    iex> Sboda.Marketing.change_radius(title, radius)
       {:ok, %Promocode{}} | {:changeset_error, %Ecto.Changeset{}} | {:error, term()}
    ```
    >Test are include


**-[ X ]- To test the validity of the promo code, expose an endpoint that accept origin, destination,
the promo code. The API should return the promo code details and a polyline using the
destination and origin if promo code is valid and an error otherwise.
**
<br/>

For this task I created
`post("/ride/request", RideController, :request)`
<br/>

Endpoint which takes in origin, destination and the promocode title. `@params`

 POST_URL: `http://localhost:4000/api/v1/ride/request`

 ```
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
 ```
 To generate the polyline I created a simple **DirectionApi** wrapper to get the polystring and decode into a list of coordinates.

 ![Alt text](https://dl3.pushbulletusercontent.com/5ZEne1D5WlWrP8aaADOhG8vtDjIKtBxt/request_ride.png "Postman example query")

### Extras
**-[ X ]-** Created endpoints for getting all promo codes, updating radius and getting active promo codes.
