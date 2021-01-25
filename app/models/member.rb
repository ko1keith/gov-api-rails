class Member < ApplicationRecord
  belongs_to :constituency, optional: true
  has_many :expenditures
end
