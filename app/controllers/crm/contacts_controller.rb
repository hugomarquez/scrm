class Crm::ContactsController < ApplicationController
  before_action :set_contact, only:[:edit, :show, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::ContactDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  def lookup
    respond_to do |format|
      format.json { render json: Crm::ContactLookup.new(view_context) }
    end
  end

  def new
    @contact = Crm::Contact.new
    @contact.build_person
    authorize @contact
  end

  def edit
    authorize @contact
    @contact.account_label = @contact.account.name if @contact.account
  end

  def show
    authorize @contact
    @tasks = @contact.tasks.page(params[:task_page]).per(5)
    @notes = @contact.notes.page(params[:note_page]).per(5)
  end

  def create
    @contact = Crm::Contact.new(contact_params)
    @contact.created_by = current_user
    authorize @contact
    if !contact_params[:account_label].blank? && contact_params[:account_id].blank?
      @account = Crm::Account.where('name Like :name OR number LIKE :name', name: contact_params[:account_label]).first
      @contact.account = @account if @account
    else
      @contact.account_id = contact_params[:account_id]
    end

    if @contact.valid?
      @contact.save
      flash[:success] = t('controllers.crm/contacts.create.success')
      redirect_to crm_contact_path(@contact)
    else
      render :new
    end
  end

  def update
    authorize @contact
    @contact.attributes = contact_params
    # If no contact is selected
    if contact_params[:account_label].blank?
      @contact.account = nil
    end

    if @contact.valid?
      @contact.save
      flash[:success] = t('controllers.crm/contacts.update.success')
      redirect_to crm_contact_path(@contact)
    else
      render :edit
    end
  end

  def destroy
    authorize @contact
    @contact.destroy
    flash[:success] = t('controllers.crm/contacts.destroy.success')
    redirect_to crm_contacts_path
  end

  private

  def set_contact
    @contact = Crm::Contact.includes(:person, :created_by).friendly.find(params[:id])
  end

  def contact_params
    params.require(:crm_contact).permit(
      :account_label, :account_id, :description, :created_by_id, :lead_source,
      :level, :language, :number,
      person_attributes:
        [:_destroy, :id, :title, :first_name, :last_name, :phone, :home_phone,
          :other_phone, :email, :assistant, :asst_phone, :extension, :mobile,
          :birthdate
        ]
    )
  end
end
