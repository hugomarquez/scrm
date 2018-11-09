class Core::DashboardController < ApplicationController
  def index
    @user_count = Core::User.all.count
    @activities = PublicActivity::Activity.all
  end
end
