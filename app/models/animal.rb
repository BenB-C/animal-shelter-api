class Animal < ApplicationRecord
  validates :animal_type, presence: true
  validates :name, presence: true
  validates :breed, presence: true
  validates :sex, presence: true
  validates :age, presence: true
  validates :age, numericality: { greater_than: 0 }
  validates :weight, presence: true
  validates :weight, numericality: { greater_than: 0 }

  scope :random, -> { limit(1).order(Arel.sql("RANDOM()")) }
  scope :find_by_type, -> (animal_type) { where("animal_type ILIKE ?", "#{animal_type[0...3]}%") if animal_type.present? }
  scope :find_by_breed, -> (breed) { where("breed ILIKE ?", "%#{breed}%") if breed.present? }
  scope :find_by_sex, -> (sex) { where("sex ILIKE ?", "#{sex}%") if sex.present? }
  scope :find_by_min_age, -> (min_age) { where("age >= ?", "#{min_age}") if min_age.present? }
  scope :find_by_max_age, -> (max_age) { where("age <= ?", "#{max_age}") if max_age.present? }
  scope :find_by_min_weight, -> (min_weight) { where("weight >= ?", "#{min_weight}") if min_weight.present? }
  scope :find_by_max_weight, -> (max_weight) { where("weight <= ?", "#{max_weight}") if max_weight.present? }
end
