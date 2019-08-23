FactoryBot.define do
  factory :animal do
    sex { ['Male', 'Female'].sample }
    age { Random.rand(1..20) }
    factory :dog do
      animal_type { 'Dog' }
      name { Faker::Creature::Dog.name }
      breed { Faker::Creature::Dog.breed }
      weight { Random.rand(10..100) }
    end
    factory :cat do
      animal_type { 'Dog' }
      name { Faker::Creature::Cat.name }
      breed { Faker::Creature::Cat.breed }
      weight { Random.rand(1..20) }
    end
  end
end
