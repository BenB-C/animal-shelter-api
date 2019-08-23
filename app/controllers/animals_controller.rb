class AnimalsController < ApplicationController
  before_action :set_animal, only: [:show, :update, :destroy]

  # GET /animals
  def index
    @animals = Animal.all

    render json: @animals
  end

  # GET /animals/1
  def show
    render json: @animal
  end

  # POST /animals
  def create
    @animal = Animal.create!(animal_params)
    render json: @animal, status: :created, location: @animal
  end

  # PATCH/PUT /animals/1
  def update
    @animal.update!(animal_params)
    render json: @animal
  end

  # DELETE /animals/1
  def destroy
    @animal.destroy!
    render json: { message: 'Animal deleted' }, status: :ok

  end

  # GET /random_animal
  def random
    @animal = Animal.random
    # @animal = Animal.all.sample
    render json: @animal
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal
      @animal = Animal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def animal_params
      params.permit(:animal_type, :name, :breed, :sex, :age, :weight)
    end
end
