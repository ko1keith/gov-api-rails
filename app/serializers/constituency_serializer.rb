class ConstituencySerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :name, :district_number, :region, :area, :population, :number_of_electors, :current_caucus

  # def constituency
  #   {
  #     name: object.constituency.name,
  #     district_number: object.constituency.district_number
  #   }
  # end
end
