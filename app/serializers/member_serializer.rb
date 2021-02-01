class MemberSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :email, :first_name, :last_name, :website, :party, :constituency

  attribute :constituency do |object|
    {
      "id": object.constituency.id,
      "name": object.constituency.name,
      "current_caucus": object.constituency.current_caucus,
      "district_member": object.constituency.district_number,
      "region": object.constituency.region,
      "area": object.constituency.area,
      "population": object.constituency.population,
      "number_of_electors": object.constituency.number_of_electors
    }
  end
end
