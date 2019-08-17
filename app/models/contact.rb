class Contact < ApplicationRecord
  belongs_to :owner, class_name: "User"

  validates :name, :owner_id, presence: true

  def self.search(query)
    if query.present?
      where("name ilike :q or mobile ilike :q or work ilike :q or office ilike :q", q: "%#{query}%")
    else
      where(nil)
    end
  end
end
