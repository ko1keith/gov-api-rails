class Expenditure < ApplicationRecord
  belongs_to :member
  belongs_to :constituency
end
