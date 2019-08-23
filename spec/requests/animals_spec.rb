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
      FactoryBot.create_list(:animal, 10)
      get animals_path
    end

    it "returns a success response" do
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
        expect(response.location).to eq(animal_url(Animal.last))
      end
    end

    context "with invalid params" do
      before do
        post '/animals', params: invalid_params
      end

      it "renders a JSON response with errors for the new animal" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
