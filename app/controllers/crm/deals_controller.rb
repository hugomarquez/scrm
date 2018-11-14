class Crm::DealsController < ApplicationController
  before_action :set_deal, only:[:edit, :show, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Crm::DealDatatable.new(view_context) }
    end
  end

  def new
    @deal = Crm::Deal.new
    authorize @deal
  end

  def show
    authorize @deal
  end

  def edit
    authorize @deal
  end

  def create
    @deal = Crm::Deal.new(deal_params)
    @deal.created_by = current_core_user
    authorize @deal
    if @deal.valid?
      @deal.save
      flash[:success] = t('controllers.crm/deals.create.success')
      redirect_to crm_deal_path(@deal)
    else
      render :new
    end
  end

  def update
    authorize @deal
    @deal.attributes = deal_params
    if @deal.valid?
      @deal.save
      flash[:success] = t('controllers.crm/deals.update.success')
      redirect_to crm_deal_path(@deal)
    else
      render :edit
    end
  end

  def destroy
    authorize @deal
    @deal.destroy
    flash[:success] = t('controllers.crm/deals.destroy.success')
    redirect_to crm_deals_path
  end

  private
  def set_deal
    @deal = Crm::Deal.includes(:account, :created_by).friendly.find(params[:id])
  end

  def deal_params
    params[:crm_deal].permit(
      :account_label, :account_id,
      :name, :category, :lead_source ,:tracking_number, :description,
      :amount, :expected_revenue, :close_at, :next_step, :stage,
      :main_competitor, :delivery_status, :number, :probability
    )
  end
end
