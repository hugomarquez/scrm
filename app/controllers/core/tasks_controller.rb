class Core::TasksController < ApplicationController
  before_action :set_task, only:[:edit, :show, :update, :destroy]

  def index
    if current_core_user
      @tasks = Core::Task.where(assigned_to: current_core_user).page(params[:task_page]).per(5)
    else
      @tasks = Core::Task.page(params[:task_page]).per(5)
    end
  end

  def new
    @task = Core::Task.new
    authorize @task
    @task.assigned_to = current_core_user
    @task.assigned_to_name = current_core_user.person.full_name
  end

  def edit
    authorize @task
    @task.assigned_to_name = @task.assigned_to.person.full_name if @task.assigned_to
    if @task.taskable
      if @task.taskable_type.constantize.reflect_on_association(:person).respond_to?(:name)
        @task.related_to = @task.taskable.person.full_name
      elsif @task.taskable.attribute_names.include?("name")
        @task.related_to = @task.taskable.name
      end
    end
  end

  def create
    @task = Core::Task.new(params_without_virtual_attributes)
    authorize @task
    if !task_params[:assigned_to_name].blank? && task_params[:assigned_to_id].blank?
      @user = Core::User.joins(:person).where('core_people.first_name Like :name OR core_people.last_name LIKE :name', name:task_params[:assigned_to_name]).first
      @task.assigned_to = @user if @user
    else
      @task.assigned_to_id = task_params[:assigned_to_id]
    end

    @task.taskable_id = polymorphic_builder(task_params[:related_to], task_params[:taskable_type], task_params[:taskable_id])

    if @task.valid?
      @task.save
      flash[:success] = t('controllers.core/tasks.create.success')
      redirect_to core_calendar_path
    else
      render :new
    end
  end

  def update
    authorize @task
    @task.attributes = params_without_virtual_attributes
    if !task_params[:assigned_to_name].blank? && task_params[:assigned_to_id].blank?
      @user = Core::User.joins(:person).where('core_people.first_name Like :name OR core_people.last_name LIKE :name', name:task_params[:assigned_to_name]).first
      @task.assigned_to = @user if @user
    else
      @task.assigned_to_id = task_params[:assigned_to_id]
    end

    @task.taskable_id = polymorphic_builder(task_params[:related_to], task_params[:taskable_type], task_params[:taskable_id])

    if @task.valid?
      @task.save
      flash[:success] = t('controllers.core/tasks.update.success')
      redirect_to core_calendar_path
    else
      render :edit
    end
  end

  def destroy
    authorize @task
    if @task.destroy
      flash[:success] = t('controllers.core/tasks.destroy.success')
      redirect_to core_tasks_path
    end
  end

  private
  def set_task
    @task = Core::Task.includes(:assigned_to, :taskable).friendly.find(params[:id])
  end

  def task_params
    params.require(:core_task).permit(
      :assigned_to_id, :taskable_type, :taskable_id,
      :status, :subject, :description, :priority, :location,
      :starts_at, :ends_at, :assigned_to, :assigned_to_name, :related_to,
    )
  end

  def params_without_virtual_attributes
    task_params.select do |p|
      p.exclude?('taskable_id') and
      p.exclude?('related_to') and
      p.exclude?('assigned_to_name') and
      p.exclude?('assigned_to_id') and
      p.exclude?('assigned_to')
    end
  end
end
