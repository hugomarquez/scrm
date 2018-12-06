class Crm::AccountsController < ApplicationController
  before_action :set_account, only:[:edit, :show, :update, :destroy]

  # Metodo para definir la respuesta de ingresar a el modulo de indice
  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::AccountDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  # Metodo para manejar solicitudes de busqueda de una cuenta
  def lookup
    respond_to do |format|
      format.json { render json: Crm::AccountLookup.new(view_context) }
    end
  end

  # Definicion de cuenta nueva
  def new
    @account = Crm::Account.new
    authorize @account
  end

  # Definicion de informacion a mostrar en el detalle de la cuenta
  def show
    authorize @account
    # Se muestran 5 registros por pagina de dataTable
    @deals = @account.deals.includes(:created_by).page(params[:deal_page]).per(5)
    @contacts = @account.contacts.includes(:person, :created_by).page(params[:contact_page]).per(5)
    @tasks = @account.tasks.page(params[:task_page]).per(5)
    @notes = @account.notes.page(params[:note_page]).per(5)
  end

  def edit
    authorize @account
  end

  def create
    # Preparacion de cuenta nueva
    @account = Crm::Account.new(account_params)
    # Fijar creador de cuenta como el usuario actualmente en control
    @account.created_by = current_user
    authorize @account
    if @account.valid?
      @account.save
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/accounts.create.success')
      redirect_to crm_accounts_path
    else
      render :new
    end
  end

  def update
    authorize @account
    if @account.update(account_params)
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/accounts.update.success')
      # Redirige a catalogo de cuentas
      redirect_to crm_account_path(@account)
    else
      # Refresca el formulario de actualizacion
      render :edit
    end
  end

  def destroy
    authorize @account
    @account.destroy
    # Mandar notificacion a la interfaz del exito de la operacion
    flash[:success] = t('controllers.crm/accounts.destroy.success')
    # Redirige a catalogo de cuentas
    redirect_to crm_accounts_path
  end

  private

  def set_account
    @account = Crm::Account.includes(:created_by).friendly.find(params[:id])
  end

  def account_params
    # Filtro de parametros permitidos
    params.require(:crm_account).permit(
      :name, :number, :website, :industry, :annual_revenue, :rating,
      :ownership, :priority, :employees, :locations, :sic_code, :active,
      :ticker_symbol, :description, :phone, :email, :extension
    )
  end
end
