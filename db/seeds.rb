# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
Member.all.destroy_all
Constituency.all.destroy_all
(1..100).each do |_index|
  member = Member.new(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    website: Faker::Internet.url,
    party: Faker::Name.political_party,
    status: 'active'
  )

  constituency = Constituency.create!(
    district_number: Faker::Number.number(digits: 5),
    region: Faker::Nation.capital_city,
    area: '100km',
    population: Faker::Number.number(digits: 7),
    number_of_electors: Faker::Number.number(digits: 6),
    name: Faker::Address.city,
    current_caucus: Faker::Name.political_party
  )

  member.constituency = constituency
  member.save
end
