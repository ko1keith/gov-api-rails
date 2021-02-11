class ConstituencySerializer
  include JSONAPI::Serializer

  attributes :name, :district_number, :region, :area, :population, :number_of_electors, :current_caucus
end
