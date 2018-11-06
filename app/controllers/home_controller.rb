class HomeController < ApplicationController
  skip_before_action :authenticate_core_user!, only: [:index]

  def index
  end
end
