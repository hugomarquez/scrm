class Core::DashboardController < ApplicationController
  def dashboard
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:activity_page]).per(5)
    @deals_by_stage = Crm::Deal.by_stage
    @deal_amount_expected = Crm::Deal.amount_v_expected
  end

  def calendar
  end

  def destroy_activities
    @activities = PublicActivity::Activity.where(owner: current_user)
    @activities.destroy_all
    redirect_to core_root_path
  end
end
