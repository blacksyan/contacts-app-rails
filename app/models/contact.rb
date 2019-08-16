class Contact < ApplicationRecord
  belongs_to :owner, class_name: "User"

  validates :owner_id, presence: true
end
