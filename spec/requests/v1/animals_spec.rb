require 'rails_helper'

RSpec.describe "V1::Animals", type: :request do

  let(:valid_params) {
    {
      animal_type: "Dog",
      name: "Abigail",
      breed: "Shepherd - Hound",
      sex: "Female",
      age: 1,
      weight: 49.5
    }
  }

  let(:invalid_params) {
    {
      animal_type: nil,
      name: '',
      breed: '',
      sex: '',
      age: 0,
      weight: 0
    }
  }

  before(:each) { Animal.destroy_all }

  describe "GET /v1/animals" do
    before do
      FactoryBot.create_list(:cat, 10)
      get v1_animals_path
    end

    it "returns a success status" do
      expect(response).to have_http_status(:success)
    end

    it "returns all animals" do
      expect(JSON.parse(response.body).size).to eq(Animal.count)
    end
  end

  describe "POST /v1/animals" do
    context "with valid params" do
      before do
        post '/v1/animals', params: valid_params
      end

      it "cretes a new Animal" do
        expect(Animal.count).to eq(1)
      end

      it "renders a JSON response with the new animal" do
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        animal = Animal.find(JSON.parse(response.body)["id"])
        expect(response.location).to eq(v1_animal_url(animal))
        expect_animal_to_match_params(animal, valid_params)
      end
    end

    context "with invalid params" do
      before do
        post '/v1/animals', params: invalid_params
      end

      it "returns a unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /v1/animals/:id" do
    let (:animal) { FactoryBot.create(:dog) }

    context "with valid :id" do
      before do
        get "/v1/animals/#{animal.id}"
      end

      it "returns a success status" do
        expect(response).to have_http_status(:success)
      end

      it "renders a JSON response with the animal" do
        expect(response.content_type).to eq('application/json')
        expect_json_response_to_match_animal(response, animal)
      end

    end

    context "with invalid :id" do
      it "returns a not_found status" do
        get "/v1/animals/foo"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT /v1/animals/:id" do
    let (:animal) { FactoryBot.create(:cat) }

    context "with valid :id and params" do
      before do
        put "/v1/animals/#{animal.id}", params: valid_params
        animal.reload
      end

      it "returns a success status" do
        expect(response).to have_http_status(:success)
      end

      it "updates the requested animal" do
        expect_animal_to_match_params(animal, valid_params)
      end

      it "renders a JSON response with the animal" do
        expect(response.content_type).to eq('application/json')
        expect_json_response_to_match_animal(response, animal)
      end
    end

    context "with valid :id and invalid params" do
      it "returns a unprocessable_entity status" do
        put "/v1/animals/#{animal.id}", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with invalid :id" do
      it "returns a not_found status" do
        put "/v1/animals/foo", params: valid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /v1/animals/:id" do
    let (:animal) { FactoryBot.create(:dog) }

    context "with valid :id" do
      it "destroys the requested animal" do
        delete "/v1/animals/#{animal.id}"
        expect(response).to have_http_status(:ok)
        get "/v1/animals/#{animal.id}"
        expect(response).to have_http_status(:not_found)
      end
    end
    context "with invalid :id" do
      it "returns a not_found status" do
        delete "/v1/animals/foo"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /v1/random" do
    before do
      get '/v1/random'
    end

    it "returns a JSON response with status ok" do
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /v1/search" do
    before do
    end

    context "with valid params" do
      it "returns only dogs if animal_type=dog is passed" do
        FactoryBot.create_list(:dog, 10)
        FactoryBot.create_list(:cat, 20)
        get "/v1/search", params: { animal_type: "dog" }
        response_body = JSON.parse(response.body)
        expect(response_body.size).to eq(10)
        response_body.each do |animal|
          expect(animal["animal_type"]).to eq("Dog")
        end
      end

      it "returns only cats if animal_type=cats is passed" do
        FactoryBot.create_list(:dog, 10)
        FactoryBot.create_list(:cat, 20)
        get "/v1/search", params: { animal_type: "cats" }
        response_body = JSON.parse(response.body)
        expect(response_body.size).to eq(20)
        response_body.each do |obj|
          expect(obj["animal_type"]).to eq("Cat")
        end
      end

      it "returns only retrievers if breed=retriever is passed" do
        animal = FactoryBot.create(:dog, breed: "Retriever")
        FactoryBot.create(:dog, breed: "Shepherd")
        get "/v1/search", params: { breed: "retriever" }
        response_body = JSON.parse(response.body)
        response_body.each do |obj|
          expect(obj["breed"].include?("Retriever")).to eq(true)
        end
        animal_found = false
        response_body.each do |obj|
          if obj["id"] == animal.id
            animal_found = true
            break
          end
        end
        expect(animal_found).to eq(true)
      end

      it "returns only male animals if sex=male is passed" do
        animal = FactoryBot.create(:dog, sex: "Male")
        FactoryBot.create(:dog, sex: "Cat")
        get "/v1/search", params: { sex: "male" }
        response_body = JSON.parse(response.body)
        response_body.each do |obj|
          expect(obj["sex"]).to eq("Male")
        end
        animal_found = false
        response_body.each do |obj|
          if obj["id"] == animal.id
            animal_found = true
            break
          end
        end
        expect(animal_found).to eq(true)
      end

      it "returns only animals over a certain age if min_age is given" do
        animal = FactoryBot.create(:dog, age: 10)
        FactoryBot.create(:dog, age: 5)
        get "/v1/search", params: { min_age: 6 }
        response_body = JSON.parse(response.body)
        response_body.each do |obj|
          expect(obj["age"] >= 6).to be(true)
        end
        animal_found = false
        response_body.each do |obj|
          if obj["id"] == animal.id
            animal_found = true
            break
          end
        end
        expect(animal_found).to eq(true)
      end

      it "returns only animals under a certain age if max_age is given" do
        animal = FactoryBot.create(:dog, age: 5)
        FactoryBot.create(:dog, age: 10)
        get "/v1/search", params: { max_age: 6 }
        response_body = JSON.parse(response.body)
        response_body.each do |obj|
          expect(obj["age"] <= 6).to be(true)
        end
        animal_found = false
        response_body.each do |obj|
          if obj["id"] == animal.id
            animal_found = true
            break
          end
        end
        expect(animal_found).to eq(true)
      end

      it "returns only animals within a certain age range if min_age and max_age are given" do
        animal = FactoryBot.create(:dog, age: 5)
        FactoryBot.create(:dog, age: 10)
        FactoryBot.create(:cat, age: 1)
        get "/v1/search", params: { min_age: 2, max_age: 9 }
        response_body = JSON.parse(response.body)
        response_body.each do |obj|
          age = obj["age"]
          expect(2 <= age).to be(true)
          expect(age <= 9).to be(true)
        end
        animal_found = false
        response_body.each do |obj|
          if obj["id"] == animal.id
            animal_found = true
            break
          end
        end
        expect(animal_found).to eq(true)
      end

      it "returns only female cats if animal_type=cats and sex=female are passed" do
        animal = FactoryBot.create(:cat, sex: "Female")
        FactoryBot.create(:dog, sex: "Female")
        FactoryBot.create(:cat, sex: "Male")
        get "/v1/search", params: { animal_type: "cats", sex: "female" }
        response_body = JSON.parse(response.body)
        response_body.each do |obj|
          expect(obj["animal_type"]).to eq("Cat")
          expect(obj["sex"]).to eq("Female")
        end
        animal_found = false
        response_body.each do |obj|
          if obj["id"] == animal.id
            animal_found = true
            break
          end
        end
        expect(animal_found).to eq(true)
      end
    end

    context "with invalid params" do
      it "returns a JSON response with status unprocessable_entity" do
        get "/v1/search", params: { foo: "Dog" }
        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # Helper methods
  def expect_json_response_to_match_animal(response, animal)
    response_body = JSON.parse(response.body)
    expect(response_body["id"]).to eq(animal.id)
    expect(response_body["animal_type"]).to eq(animal.animal_type)
    expect(response_body["name"]).to eq(animal.name)
    expect(response_body["breed"]).to eq(animal.breed)
    expect(response_body["sex"]).to eq(animal.sex)
    expect(response_body["age"].to_f).to eq(animal.age)
    expect(response_body["weight"].to_f).to eq(animal.weight)
  end

  def expect_animal_to_match_params(animal, params)
    expect(animal.animal_type).to eq(params[:animal_type])
    expect(animal.name).to eq(params[:name])
    expect(animal.breed).to eq(params[:breed])
    expect(animal.sex).to eq(params[:sex])
    expect(animal.age).to eq(params[:age])
    expect(animal.weight).to eq(params[:weight])
  end
end
