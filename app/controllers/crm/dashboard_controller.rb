class Crm::DashboardController < ApplicationController
  def index
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:activity_page]).per(5)
  end
end
