class Crm::LeadsController < ApplicationController
  before_action :set_lead, only:[:clone, :convert, :edit, :show, :update, :destroy]

  # Metodo para definir la respuesta de ingresar al catalogo
  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::LeadDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  # Metodo para manejar solicitudes de busqueda de lead
  def lookup
    respond_to do |format|
      format.json { render json: Crm::LeadLookup.new(view_context) }
    end
  end

  # Especificacion de funcionalidad de clonacion de leads
  def clone
    authorize @lead
    # Se clona el lead junto con sus datos asociados
    @new_lead = @lead.clone_with_associations
    if @new_lead.valid?
      @new_lead.save
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/leads.clone.success')
      # Redirige al detalle del lead nuevo
      redirect_to crm_lead_path(@new_lead)
    else
      # Refresca el formulario de creacion
      render :new
    end
  end

  def convert
    # Toma los datos del lead y los inserta en una cuenta nueva
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

    #Definicion de nuevo deal con la infromacion de cuenta y nombre de compania del lead
    @deal = Crm::Deal.new(
      account: @account,
      name: @lead.company.to_s + " - " + Date.today.to_s,
      # Categorizar como cliente nuevo
      category: :new_customer,
      # Fijar en etapa de prospeccion
      stage: :prospecting,
      # Fijar tiempo de cierre a 30 dias despues
      close_at: Time.now + 30.days,
      created_by: current_core_user
    )
    # Si la cuenta y deal son validos, guardarlos
    if @account.valid? && @deal.valid?
      @account.save
      @deal.save
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/leads.convert.success')
      # Redirigir a detalle de cuenta nueva
      redirect_to crm_account_path(@account)
      #TODO: else flash error and redirect to lead path
    end
  end

  # Definicion de lead nuevo
  def new
    @lead = Crm::Lead.new
    @lead.build_person
    authorize @lead
  end

  # Definicion de informacion a mostrar en el detalle del deal
  def show
    authorize @lead
    # Se muestran 5 registros por pagina de dataTable
    @tasks = @lead.tasks.page(params[:task_page]).per(5)
    @notes = @lead.notes.page(params[:note_page]).per(5)
  end

  def edit
    authorize @lead
  end

  def create
    # Preparacion de lead nuevo
    @lead = Crm::Lead.new(lead_params)
    @lead.created_by = current_core_user
    authorize @lead
    if @lead.valid?
      @lead.save
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/leads.create.success')
      # Redirigir a catalogo de leads
      redirect_to crm_leads_path
    else
      # Refrescar formulario de creacion
      render :new
    end
  end

  def update
    authorize @lead
    if @lead.update_attributes(lead_params)
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/leads.update.success')
      # Redirigir a detalle de lead
      redirect_to crm_lead_path(@lead)
    else
      # Refrescar formulario de edicion
      render :edit
    end
  end

  def destroy
    authorize @lead
    @lead.destroy
    # Mandar notificacion a la interfaz del exito de la operacion
    flash[:success] = t('controllers.crm/leads.destroy.success')
    # redirigir a catalogo de leads
    redirect_to crm_leads_path
  end

  private
  def set_lead
    @lead = Crm::Lead.includes(:person, :created_by).friendly.find(params[:id])
  end

  def lead_params
    # Filtro de parametros permitidos
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
