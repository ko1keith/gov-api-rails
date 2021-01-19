class Member < ApplicationRecord
  belongs_to :constituency, optional: true
end
