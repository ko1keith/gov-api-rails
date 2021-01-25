class Constituency < ApplicationRecord
  has_one :member
  has_many :addresses
  has_many :expenditures
end
