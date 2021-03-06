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
        expect(response.body).to include("Couldn't find User")
      end
    end
  end

  describe 'Search user contacts' do
    before do
      create(:contact, owner_id: user_id, name: "Balmond", mobile: "12345678")
    end

    context 'when user search by name' do
      it 'returns status code 200' do
        get "/users/#{user_id}/contacts", params: { query: "Balm" }
        expect(response).to have_http_status(200)
        expect(json.size).to eq(1)
        expect(json.first["name"]).to match("Balmond")
      end
    end

    context 'when user search by phone' do
      it 'returns status code 200' do
        get "/users/#{user_id}/contacts", params: { query: "12345678" }
        expect(response).to have_http_status(200)
        expect(json.size).to eq(1)
        expect(json.first["name"]).to match("Balmond")
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
        expect(response.body).to include("Couldn't find Contact")
      end
    end
  end

  describe 'Create contact' do
    let(:valid_attributes) { { name: 'Narnia', mobile: "+62818-0311-3231" } }
    let(:valid_attributes2) { 
      { 
        name: 'Ilham', 
        mobile: "+62818-0311-3231", 
        others: {
          email: "ilham@email.com",
          skype: "ilham",
          id_kaskus: "ilham.adi",
        } 
      } 
    }

    context 'when request attributes are valid' do
      before { post "/users/#{user_id}/contacts", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when user have others attributes' do
      before { post "/users/#{user_id}/contacts", params: valid_attributes2 }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end    

    context 'when an invalid request' do
      before { post "/users/#{user_id}/contacts", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
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
        updated_contact = Contact.find(id)
        expect(updated_contact.name).to match(/Mozart/)
      end
    end

    context 'when the contact does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Contact")
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