class V1::AnimalsController < ApplicationController
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
    render json: @animal, status: :created, location: v1_animal_url(@animal)
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

  # GET /random
  def random
    @animal = Animal.random[0]
    render json: @animal
  end

  # GET /search
  def search
    allowed_keys = %w[animal_type breed sex min_age max_age min_weight max_weight]
    passed_keys = params.keys - %w[controller action]
    invalid_keys = passed_keys - allowed_keys
    if invalid_keys.any?
      message = "Invalid search keys: #{invalid_keys.join(', ')}. Valid keys are: #{allowed_keys.join(', ')}"
      render json: { message: message }, status: :unprocessable_entity
    else
      @animals = Animal.find_by_type(params[:animal_type])
      .find_by_breed(params[:breed])
      .find_by_sex(params[:sex])
      .find_by_min_age(params[:min_age])
      .find_by_max_age(params[:max_age])
      .find_by_min_weight(params[:min_weight])
      .find_by_max_weight(params[:max_weight])
      render json: @animals
    end
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
