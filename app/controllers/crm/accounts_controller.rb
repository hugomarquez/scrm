class Crm::AccountsController < ApplicationController
  before_action :set_account, only:[:edit, :show, :update, :destroy]

  def home
    @accounts = Crm::Account.recent
  end

  def index
    @accounts = Crm::Account.all
  end

  def new
    @account = Crm::Account.new
    authorize @account
  end

  def show
    authorize @account
  end

  def edit
    authorize @account
  end

  def create
    @account = Crm::Account.new(account_params)
    @account.created_by = current_user
    authorize @account
    if @account.valid?
      @account.save
      redirect_to crm_accounts_path
    else
      render :new
    end
  end

  def update
    authorize @account
    if @account.update(account_params)
      redirect_to crm_account_path(@account)
    else
      render :edit
    end
  end

  def destroy
    authorize @account
    @account.destroy
    redirect_to crm.home_accounts_path
  end

  private

  def set_account
    @account = Crm::Account.includes(:created_by).friendly.find(params[:id])
  end

  def account_params
    params.require(:crm_account).permit(
      :name, :number, :website, :industry, :annual_revenue, :rating,
      :ownership, :priority, :employees, :locations, :sic_code, :active,
      :ticker_symbol, :description, :phone, :email, :extension
    )
  end
end
