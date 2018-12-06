class Core::DashboardController < ApplicationController
  #Metodo dashboard que asigna valores a diferentes variables de instancia
  def dashboard
    @activities = PublicActivity::Activity.includes(:owner, :trackable).order(created_at: :desc).page(params[:activity_page]).per(5)
    @deals_by_stage = Crm::Deal.by_stage
    @deal_amount_expected = Crm::Deal.amount_v_expected
  end
  
  #Metodo calendar, no hace nada
  def calendar
  end

  #Metodo destroy_activities. Apunta asigna valores a @activities y despues los destruye
  def destroy_activities
    @activities = PublicActivity::Activity.where(owner: current_user)
    @activities.destroy_all
    redirect_to core_root_path
  end
end
