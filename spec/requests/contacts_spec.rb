require 'rails_helper'

RSpec.describe 'Contacts API' do
  let!(:user) { create(:user) }
  let!(:contacts) { create_list(:contact, 20, owner_id: user.id) }
  let(:user_id) { user.id }
  let(:id) { contacts.first.id }

  describe 'List user contacts' do
    before { get "/users/#{user_id}/contacts" }

    context 'when user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user contacts' do
        expect(json.size).to eq(20)
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find user/)
      end
    end
  end

  describe 'Show contact detail' do
    before { get "/users/#{user_id}/contacts/#{id}" }

    context 'when user contact exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the contact' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when user contact does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find contact/)
      end
    end
  end

  describe 'Create contact' do
    let(:valid_attributes) { { name: 'Narnia', mobile: "+62818-0311-3231" } }

    context 'when request attributes are valid' do
      before { post "/users/#{user_id}/contacts", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/users/#{user_id}/contacts", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'Update contact' do
    let(:valid_attributes) { { name: 'Mozart' } }

    before { put "/users/#{user_id}/contacts/#{id}", params: valid_attributes }

    context 'when contact exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the contact' do
        updated_contact = contact.find(id)
        expect(updated_contact.name).to match(/Mozart/)
      end
    end

    context 'when the contact does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find contact/)
      end
    end
  end

  describe 'Delete contact' do
    before { delete "/users/#{user_id}/contacts/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end