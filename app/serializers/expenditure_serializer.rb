class ExpenditureSerializer < ActiveModel::Serializer
  attributes :category, :subcategory, :start_date, :end_date, :member_budget, :resources_provided_by_house, :total,
             :party, :member

  def member
    {
      first_name: object.member.first_name,
      last_name: object.member.last_name,
      party: object.member.party

    }
  end
end
