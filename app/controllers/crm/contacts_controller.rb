class Crm::ContactsController < ApplicationController
  before_action :set_contact, only:[:edit, :show, :update, :destroy]

  # Metodo para definir la respuesta de ingresar al catalogo
  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::ContactDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  # Metodo para manejar solicitudes de busqueda de un contacto
  def lookup
    respond_to do |format|
      format.json { render json: Crm::ContactLookup.new(view_context) }
    end
  end

  # Definicion de nuevo contacto
  def new
    @contact = Crm::Contact.new
    @contact.build_person
    authorize @contact
  end

  def edit
    authorize @contact
    @contact.account_label = @contact.account.name if @contact.account
  end

  # Definicion de informacion a mostrar en el detalle del contacto
  def show
    authorize @contact
    # Se muestran 5 registros por pagina de dataTable
    @tasks = @contact.tasks.page(params[:task_page]).per(5)
    @notes = @contact.notes.page(params[:note_page]).per(5)
  end

  def create
    # Preparacion de contacto nuevo
    @contact = Crm::Contact.new(contact_params)
    # Fijar creador de contacto como el usuario actualmente en sesion
    @contact.created_by = current_user
    authorize @contact
    # Si se dejo en blanco el numero de cuenta buscar primer coincidencia de posibles cuenta
    if !contact_params[:account_label].blank? && contact_params[:account_id].blank?
      @account = Crm::Account.where('name Like :name OR number LIKE :name', name: contact_params[:account_label]).first
      @contact.account = @account if @account
    else
      @contact.account_id = contact_params[:account_id]
    end

    if @contact.valid?
      @contact.save
      # Mandar notificacion a la interfaz del exito de la operacion
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
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/contacts.update.success')
      redirect_to crm_contact_path(@contact)
    else
      # Refrescar formulario de edicion
      render :edit
    end
  end

  def destroy
    authorize @contact
    @contact.destroy
    # Mandar notificacion a la interfaz del exito de la operacion
    flash[:success] = t('controllers.crm/contacts.destroy.success')
    # Redirigir a catalogo de contactos
    redirect_to crm_contacts_path
  end

  private

  def set_contact
    @contact = Crm::Contact.includes(:person, :created_by).friendly.find(params[:id])
  end

  def contact_params
    # Filtro de parametros permitidos
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
