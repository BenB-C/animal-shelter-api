require 'rails_helper'

RSpec.describe "Animals", type: :request do

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

  describe "GET /animals" do
    before do
      FactoryBot.create_list(:cat, 10)
      get animals_path
    end

    it "returns a success status" do
      expect(response).to have_http_status(:success)
    end

    it "returns all animals" do
      expect(JSON.parse(response.body).size).to eq(Animal.count)
    end
  end

  describe "POST /animals" do
    context "with valid params" do
      before do
        post '/animals', params: valid_params
      end

      it "cretes a new Animal" do
        expect(Animal.count).to eq(1)
      end

      it "renders a JSON response with the new animal" do
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        animal = Animal.find(JSON.parse(response.body)["id"])
        expect(response.location).to eq(animal_url(animal))
        expect_animal_to_match_params(animal, valid_params)
      end
    end

    context "with invalid params" do
      before do
        post '/animals', params: invalid_params
      end

      it "returns a unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /animals/:id" do
    let (:animal) { FactoryBot.create(:dog) }

    context "with valid :id" do
      before do
        get "/animals/#{animal.id}"
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
        get "/animals/foo"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT /animals/:id" do
    let (:animal) { FactoryBot.create(:cat) }

    context "with valid :id and params" do
      before do
        put "/animals/#{animal.id}", params: valid_params
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
        put "/animals/#{animal.id}", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with invalid :id" do
      it "returns a not_found status" do
        put "/animals/foo", params: valid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /animals/:id" do
    let (:animal) { FactoryBot.create(:dog) }

    context "with valid :id" do
      it "destroys the requested animal" do
        delete "/animals/#{animal.id}"
        get "/animals/#{animal.id}"
        expect(response).to have_http_status(:not_found)
      end
    end
    context "with invalid :id" do
      it "returns a not_found status" do
        delete "/animals/foo"
        expect(response).to have_http_status(:not_found)
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
