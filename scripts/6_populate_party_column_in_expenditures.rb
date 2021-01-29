Expenditure.where(party: nil).each do |expend|
  puts "Updating Expenditure party affiliation to #{expend.member.party}"
  expend.party = expend.member.party
  expend.save
end
