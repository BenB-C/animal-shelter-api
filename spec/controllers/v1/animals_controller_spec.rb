require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe V1::AnimalsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Animal. As you add validations to Animal, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      animal_type: "Dog",
      name: "Abigail",
      breed: "Shepherd - Hound",
      sex: "Female",
      age: 1,
      weight: 49.5
    }
  }

  let(:invalid_attributes) {
    {
      animal_type: nil,
      name: '',
      breed: '',
      sex: '',
      age: 0,
      weight: 0
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AnimalsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Animal.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      animal = Animal.create! valid_attributes
      get :show, params: {id: animal.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Animal" do
        expect {
          post :create, params: valid_attributes, session: valid_session
        }.to change(Animal, :count).by(1)
      end

      it "renders a JSON response with the new animal" do

        post :create, params: valid_attributes, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(v1_animal_url(Animal.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new animal" do

        post :create, params: invalid_attributes, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          animal_type: "Cat",
          name: "Aaron",
          breed: "Domestic Short Hair",
          sex: "Male",
          age: 0.333,
          weight: 6.1
        }
      }

      it "updates the requested animal" do
        animal = Animal.create! valid_attributes
        put :update, params: new_attributes.merge(id: animal.id), session: valid_session
        animal = Animal.find(animal.id)
        expect(animal.animal_type).to eq(new_attributes[:animal_type])
        expect(animal.name).to eq(new_attributes[:name])
        expect(animal.breed).to eq(new_attributes[:breed])
        expect(animal.sex).to eq(new_attributes[:sex])
        expect(animal.age).to eq(new_attributes[:age])
        expect(animal.weight).to eq(new_attributes[:weight])
      end

      it "renders a JSON response with the animal" do
        animal = Animal.create! valid_attributes
        put :update, params: new_attributes.merge(id: animal.id), session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        response_body = JSON.parse(response.body)
        animal = Animal.find(animal.id)
        expect(response_body["id"]).to eq(animal.id)
        expect(response_body["animal_type"]).to eq(animal.animal_type)
        expect(response_body["name"]).to eq(animal.name)
        expect(response_body["breed"]).to eq(animal.breed)
        expect(response_body["sex"]).to eq(animal.sex)
        expect(response_body["age"].to_f).to eq(animal.age)
        expect(response_body["weight"].to_f).to eq(animal.weight)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the animal" do
        animal = Animal.create! valid_attributes

        put :update, params: invalid_attributes.merge(id: animal.id), session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested animal" do
      animal = Animal.create! valid_attributes
      expect {
        delete :destroy, params: {id: animal.to_param}, session: valid_session
      }.to change(Animal, :count).by(-1)
    end
  end

end
