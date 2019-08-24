# Animal Shelter API

#### Epicodus Ruby and Rails - Building an API - 2019.08.23

#### By Ben Bennett-Cauchon

## Description

An API for a fictional animal shelter created using Ruby on Rails. The API lists the available cats and dogs at the shelter. There are also routes for getting a random animal and for searching for animals by type (cat or dog), breed, sex, age, and weight.

## Specifications

The API should contain:
* Endpoints for GET (all and by id), POST, PUT and DELETE.
* A RANDOM endpoint that randomly returns a park/business/animal.
* A second custom endpoint that accepts parameters (example: a SEARCH route that allows users to search by specific park names).
* Model scopes to process parameters from API calls.
* At least one of the objectives from Monday's Further Exploration lesson (such as versioning, token authentication, or serialization).
* Thorough exception handling.
* Complete testing with request specs.
* Randomized data with Faker or your own custom seed code.
* A README that thoroughly documents all endpoints, including parameters that can be passed in.

## Setup

Created with Ruby version 2.5.1
* clone/download the repository
* navigate to the directory in a terminal
* run the commands:
```
bundle install
rake db:create
rake db:migrate
rake db:seed
rails server
```

## Sending Requests

* Send requests to the api through http://localhost:3000 using Curl, Postman, or a similar app
* All requests should return a JSON object with the requested records, a confirmation message (when deleting a record), or an error message (when invalid parameters are passed in)

## API Endpoints

#### GET /animals

* Returns a list of all animals
* Http status: 200

#### GET /animals/:id

* Returns the animal with the given :id, or an error message if no animal exists with the given :id
* Http status: 200 (valid :id) or 404 (invalid :id)

Sample Request:<br>
`GET http://localhost:3000/animals/1`

Sample Response:
```
{
    "id": 1,
    "animal_type": "Cat",
    "name": "Jasper",
    "breed": "Oriental Bicolor",
    "sex": "Male",
    "age": 15,
    "weight": 19,
    "created_at": "2019-08-23T22:35:47.068Z",
    "updated_at": "2019-08-23T22:35:47.068Z"
}
```
#### POST /animals

* Adds an animal record to the database
* Parameters:
  * `animal_type`
  * `breed`
  * `name`
  * `sex`
  * `age` (in years)
  * `weight` (in pounds)
* Http status: 201 (valid params) or
422 (invalid params)

Sample Request:<br>
`POST http://localhost:3000/animals/?animal_type=Dog&name=Abigail&breed=Shepherd&sex=Female&age=1&weight=49.5`

Sample Response:
```
{
    "id": 13,
    "animal_type": "Dog",
    "name": "Abigail",
    "breed": "Shepherd",
    "sex": "Female",
    "age": 1,
    "weight": 49.5,
    "created_at": "2019-08-24T00:35:55.483Z",
    "updated_at": "2019-08-24T00:35:55.483Z"
}
```

#### PATCH/PUT /animals/:id
* Edits the record with the given :id's attributes and returns the updated record
* Parameters are the same as for `POST /animals`
* Http status: 201 (valid params) or
422 (invalid params)

Sample Request:<br>
`PUT http://localhost:3000/animals/13?name=Max&weight=42`

Sample Response:
```
{
    "id": 13,
    "animal_type": "Dog",
    "name": "Max",
    "breed": "Shepherd",
    "sex": "Female",
    "age": 1,
    "weight": 42,
    "created_at": "2019-08-24T00:35:55.483Z",
    "updated_at": "2019-08-24T00:35:55.483Z"
}
```

#### DELETE /animals/:id
* Deletes the record with the given :id and returns a confirmation message
* Http status: 200 (valid :id) or 404 (invalid :id)

Sample Request:<br>
`DELETE http://localhost:3000/animals/13`

Sample Response:
```
{
    "message": "Animal deleted"
}
```

#### GET /random
* Returns a random record from the database

Sample Request:<br>
`GET http://localhost:3000/random`

Sample Response:
```
{
    "id": 355,
    "animal_type": "Cat",
    "name": "Jasper",
    "breed": "Cornish Rex",
    "sex": "Female",
    "age": 2,
    "weight": 1,
    "created_at": "2019-08-23T22:35:47.256Z",
    "updated_at": "2019-08-23T22:35:47.256Z"
}
```

#### GET /search
* Returns a list of all animals matching the given search parameters
* Parameters:
  * `animal_type`
  * `breed`
  * `sex`
  * `min_age` (in years)
  * `max_age` (in years)
  * `min_weight` (in pounds)
  * `weight` (in pounds)
* Http status: 201 (valid params) or
422 (invalid params)

Sample Request:<br>
`GET http://localhost:3000/search/?animal_type=dog&breed=shepherd&sex=female`

Sample Response:
```
[
    {
        "id": 402,
        "animal_type": "Dog",
        "name": "Abigail",
        "breed": "Shepherd - Hound",
        "sex": "Female",
        "age": 1,
        "weight": 49.5,
        "created_at": "2019-08-24T00:30:01.500Z",
        "updated_at": "2019-08-24T00:30:01.500Z"
    },
    {
        "id": 403,
        "animal_type": "Dog",
        "name": "Abigail",
        "breed": "Shepherd - Hound",
        "sex": "Female",
        "age": 1,
        "weight": 49.5,
        "created_at": "2019-08-24T00:32:23.667Z",
        "updated_at": "2019-08-24T00:32:23.667Z"
    },
    {
        "id": 303,
        "animal_type": "Dog",
        "name": "max",
        "breed": "Shepherd - Hound",
        "sex": "Female",
        "age": 1,
        "weight": 49.5,
        "created_at": "2019-08-23T22:35:47.068Z",
        "updated_at": "2019-08-24T00:52:53.880Z"
    },
    {
        "id": 398,
        "animal_type": "Dog",
        "name": "Chance",
        "breed": "Germanshepherd",
        "sex": "Female",
        "age": 12,
        "weight": 46,
        "created_at": "2019-08-23T22:35:47.438Z",
        "updated_at": "2019-08-23T22:35:47.438Z"
    }
]
```

## Support and contact details

If you find a bug, run into any issues, or have questions, ideas or concerns please feel free to submit an issue for the project here on GitHub.

## Technologies Used

* Ruby on Rails
* ActiveRecord
* RSpec
* Shoulda-Matchers
* Faker
* FactoryBot
* SimpleCov

### License

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2019 Benjamin Bennett-Cauchon
