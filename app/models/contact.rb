require 'elasticsearch/model'

class Contact < ApplicationRecord
  belongs_to :owner, class_name: "User"
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

  validates :name, :owner_id, presence: true

  def as_indexed_json(options = {})
    self.as_json(
      only: [:name, :mobile, :work, :office],
      include: {
        owner: {
          only: [:name]
        }
      }
    )
  end
end
