class Crm::ContactsController < ApplicationController
  before_action :set_contact, only:[:edit, :show, :update, :destroy]

  def index
  end

  def new
  end

  def edit
    authorize @contact
  end

  def show
    authorize @contact
  end

  private
  def set_contact
    @contact = Crm::Contact.includes(:person, :created_by).friendly.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(
      :language, :description, :created_by_id, :account_label, :account_id,
      person_attributes:
        [:_destroy, :id, :title, :first_name, :last_name, :phone, :home_phone,
          :other_phone, :email, :assistant, :asst_phone, :extension, :mobile,
          :birthdate
        ]
    )
  end
end
