require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { should belong_to(:owner) }

  it { should validate_presence_of(:owner_id) }
end
