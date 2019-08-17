class Contact < ApplicationRecord
  belongs_to :owner, class_name: "User"

  validates :name, :owner_id, presence: true
end
