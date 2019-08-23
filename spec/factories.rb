FactoryBot.define do
  factory :animal do
    animal_attributes = { animal_type: ['Dog', 'Cat'].sample }
    if animal_attributes[:animal_type] == 'Dog'
      animal_attributes[:name] = Faker::Creature::Dog.name
      animal_attributes[:breed] = Faker::Creature::Dog.breed
      animal_attributes[:weight] = Random.rand(10..100)
    else
      animal_attributes[:name] = Faker::Creature::Cat.name
      animal_attributes[:breed] = Faker::Creature::Cat.breed
      animal_attributes[:weight] = Random.rand(1..20)
    end
    animal_attributes[:sex] = ['Male', 'Female'].sample
    animal_attributes[:age] = Random.rand(1..20)
    animal_type { animal_attributes[:animal_type] }
    name { animal_attributes[:name] }
    breed { animal_attributes[:breed] }
    sex { animal_attributes[:sex] }
    age { animal_attributes[:age] }
    weight { animal_attributes[:weight] }
  end
end
