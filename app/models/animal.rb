class Animal < ApplicationRecord
  validates :animal_type, presence: true
  validates :name, presence: true
  validates :breed, presence: true
  validates :sex, presence: true
  validates :age, presence: true
  validates :age, numericality: { greater_than: 0 }
  validates :weight, presence: true
  validates :weight, numericality: { greater_than: 0 }

  scope :random, -> { limit(1).order("RANDOM()") }
end
