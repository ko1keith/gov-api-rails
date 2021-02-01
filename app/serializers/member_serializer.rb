class MemberSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :email, :first_name, :last_name, :website, :party, :constituency

  # def constituency
  #   {
  #     name: object.constituency.name,
  #     district_number: object.constituency.district_number
  #   }
  # end
end
