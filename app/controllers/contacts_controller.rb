class ContactsController < ApplicationController
  before_action :set_user
  before_action :set_user_contact, only: [:show, :update, :destroy]

  def index
    json_response(@user.contacts)
  end

  def show
    json_response(@contact)
  end

  def create
    @user.contacts.create!(contact_params)
    json_response(@user, :created)
  end

  def update
    @contact.update(contact_params)
    head :no_content
  end

  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def contact_params
    params.permit(:name, :done)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_contact
    @contact = @user.contacts.find_by!(id: params[:id]) if @user
  end
end
