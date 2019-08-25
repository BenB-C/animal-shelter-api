require "rails_helper"

RSpec.describe V1::AnimalsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/v1/animals").to route_to("v1/animals#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/animals/1").to route_to("v1/animals#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/v1/animals").to route_to("v1/animals#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/v1/animals/1").to route_to("v1/animals#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/v1/animals/1").to route_to("v1/animals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/v1/animals/1").to route_to("v1/animals#destroy", :id => "1")
    end
  end
end
