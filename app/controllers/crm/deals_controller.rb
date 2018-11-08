class Crm::DealsController < ApplicationController
  before_action :set_deal, only:[:edit, :show, :update, :destroy]

  def home
    @recent_deals = Crm::Deal.recent
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
    @deal.account_label = @deal.account.name if @deal.account
  end

  def create
    @deal = Crm::Deal.new(deal_params)
    @deal.created_by = current_user
    authorize @deal
    if !deal_params[:account_label].blank? && deal_params[:account_id].blank?
      @account = Crm::Account.where('name Like :name OR number LIKE :name', name: deal_params[:account_label]).first
      @deal.account = @account if @account
    else
      @deal.account_id = deal_params[:account_id]
    end

    if @deal.valid?
      @deal.save
      redirect_to crm_deal_path(@deal)
    else
      render :new
    end
  end

  def update
    authorize @deal
    @deal.attributes = deal_params
    if !deal_params[:account_label].blank? && deal_params[:account_id].blank?
      @account = Crm::Account.where('name Like :name OR number LIKE :name', name: deal_params[:account_label]).first
      @deal.account = @account if @account
    elsif !deal_params[:account_label].nil? && deal_params[:account_label].blank?
        @deal.account_id = nil
    else
      @deal.account_id = deal_params[:account_id] if deal_params[:account_id]
    end

    if @deal.valid?
      @deal.save
      redirect_to crm_deal_path(@deal)
    else
      render :edit
    end
  end

  def destroy
    authorize @deal
    @deal.destroy
    redirect_to crm_deals_path
  end

  private

  def set_deal
    @deal = Crm::Deal.includes(:account, :created_by).friendly.find(params[:id])
  end

  def deal_params
    params[:deal].permit(
      :account_label, :account_id,
      :name, :category, :lead_source ,:tracking_number, :description,
      :amount, :expected_revenue, :close_at, :next_step, :stage,
      :main_competitor, :delivery_status,

      contact_roles_attributes:
        [:_destroy, :id, :deal_id, :contact_id, :role, :primary]
    )
  end
end
