class ExpenditureSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :category, :subcategory, :start_date, :end_date, :member_budget, :resources_provided_by_house, :total,
             :party, :member

  belongs_to :member
  belongs_to :constituency

  attribute :member do |object|
    {
      "name": "#{object.member.first_name} #{object.member.last_name}",
      "party": object.member.party,
      "constituency": object.constituency.name
    }
  end

  # def member
  #   {
  #     first_name: object.member.first_name,
  #     last_name: object.member.last_name,
  #     party: object.member.party

  #   }
  # end
end
