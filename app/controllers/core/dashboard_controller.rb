class Core::DashboardController < ApplicationController
  def dashboard
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:activity_page]).per(5)
  end

  def calendar
  end
end
