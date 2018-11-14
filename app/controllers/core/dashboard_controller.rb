class Core::DashboardController < ApplicationController
  def dashboard
    @user_count = Core::User.all.count
    @activities = PublicActivity::Activity.all
  end

  def calendar
  end
end
