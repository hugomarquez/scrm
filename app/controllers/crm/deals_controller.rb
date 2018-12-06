class Crm::DealsController < ApplicationController
  before_action :set_deal, only:[:edit, :show, :update, :destroy]

  # Metodo para definir la respuesta de ingresar al catalogo
  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::DealDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  # Metodo para manejar solicitudes de busqueda de deal
  def lookup
    respond_to do |format|
      format.json { render json: Crm::DealLookup.new(view_context) }
    end
  end

  # Definicion de nuevo deal
  def new
    @deal = Crm::Deal.new
    authorize @deal
  end

  # Definicion de informacion a mostrar en el detalle del deal
  def show
    authorize @deal
    # Se muestran 5 registros por pagina de dataTable
    @tasks = @deal.tasks.page(params[:task_page]).per(5)
    @notes = @deal.notes.page(params[:note_page]).per(5)
  end

  def edit
    authorize @deal
    @deal.account_label = @deal.account.name if @deal.account
  end

  def create
    # Preparacion de deal nuevo
    @deal = Crm::Deal.new(deal_params)
    # Fijar creador de contacto como el usuario core actualmente en sesion
    @deal.created_by = current_core_user
    authorize @deal
    if @deal.valid?
      @deal.save
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/deals.create.success')
      # Redirigir a detalle del nuevo deal
      redirect_to crm_deal_path(@deal)
    else
      # Refrescar formulario de creacion
      render :new
    end
  end

  def update
    authorize @deal
    @deal.attributes = deal_params
    if @deal.valid?
      @deal.save
      # Mandar notificacion a la interfaz del exito de la operacion
      flash[:success] = t('controllers.crm/deals.update.success')
      redirect_to crm_deal_path(@deal)
    else
      # Refrescar formulario de edicion
      render :edit
    end
  end

  def destroy
    authorize @deal
    @deal.destroy
    # Mandar notificacion a la interfaz del exito de la operacion
    flash[:success] = t('controllers.crm/deals.destroy.success')
    redirect_to crm_deals_path
  end

  private
  def set_deal
    @deal = Crm::Deal.includes(:account, :created_by).friendly.find(params[:id])
  end

  def deal_params
    # Filtro de parametros permitidos
    params[:crm_deal].permit(
      :account_label, :account_id,
      :name, :category, :lead_source ,:tracking_number, :description,
      :amount, :expected_revenue, :close_at, :next_step, :stage,
      :main_competitor, :delivery_status, :number, :probability
    )
  end
end
