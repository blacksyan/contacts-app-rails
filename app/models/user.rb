class User < ApplicationRecord
  has_many :contacts, foreign_key: :owner_id, dependent: :destroy

  validates :name, presence: true
end
