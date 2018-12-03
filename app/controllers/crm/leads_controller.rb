class Crm::LeadsController < ApplicationController
  before_action :set_lead, only:[:clone, :convert, :edit, :show, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::LeadDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  def lookup
    respond_to do |format|
      format.json { render json: Crm::LeadLookup.new(view_context) }
    end
  end

  def clone
    authorize @lead
    @new_lead = @lead.clone_with_associations
    if @new_lead.valid?
      @new_lead.save
      flash[:success] = t('controllers.crm/leads.clone.success')
      redirect_to crm_lead_path(@new_lead)
    else
      render :new
    end
  end

  def convert
    @account = Crm::Account.new(
      name: @lead.company,
      industry: @lead.industry,
      rating: @lead.rating,
      website: @lead.website,
      description: @lead.description,
      phone: @lead.person.phone,
      extension: @lead.person.extension,
      created_by: current_core_user,
    )
    @contact = @account.contacts.build(created_by: current_core_user)
    @contact.build_person(@lead.person.dup.attributes)

    @deal = Crm::Deal.new(
      account: @account,
      name: @lead.company.to_s + " - " + Date.today.to_s,
      category: :new_customer,
      stage: :prospecting,
      close_at: Time.now + 30.days,
      created_by: current_core_user
    )
    if @account.valid? && @deal.valid?
      @account.save
      @deal.save
      flash[:success] = t('controllers.crm/leads.convert.success')
      redirect_to crm_account_path(@account)
      #TODO: else flash error and redirect to lead path
    end
  end

  def new
    @lead = Crm::Lead.new
    @lead.build_person
    authorize @lead
  end

  def show
    authorize @lead
    @tasks = @lead.tasks.page(params[:task_page]).per(5)
    @notes = @lead.notes.page(params[:note_page]).per(5)
  end

  def edit
    authorize @lead
  end

  def create
    @lead = Crm::Lead.new(lead_params)
    @lead.created_by = current_core_user
    authorize @lead
    if @lead.valid?
      @lead.save
      flash[:success] = t('controllers.crm/leads.create.success')
      redirect_to crm_leads_path
    else
      render :new
    end
  end

  def update
    authorize @lead
    if @lead.update_attributes(lead_params)
      flash[:success] = t('controllers.crm/leads.update.success')
      redirect_to crm_lead_path(@lead)
    else
      render :edit
    end
  end

  def destroy
    authorize @lead
    @lead.destroy
    flash[:success] = t('controllers.crm/leads.destroy.success')
    redirect_to crm_leads_path
  end

  private
  def set_lead
    @lead = Crm::Lead.includes(:person, :created_by).friendly.find(params[:id])
  end

  def lead_params
    params.require(:crm_lead).permit(
      :id, :source, :company, :industry, :sic_code, :status,
      :website, :rating, :description, :created_by_id,
      :number,
      person_attributes:
        [:_destroy, :id, :title, :first_name, :last_name, :phone, :home_phone,
          :other_phone, :email, :assistant, :asst_phone, :extension, :mobile,
          :birthdate
        ]
    )
  end
end
