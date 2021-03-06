class Core::UsersController < ApplicationController
  before_action :set_user, only:[:edit, :show, :update, :send_invite]
  # GET /users
  def index
    respond_to do |format|
      format.html
      format.json { render json: Core::UserDatatable.new(view_context) }
    end
  end

  #TODO: Implement this on an api controller with user - api token authentication
  def lookup
    respond_to do |format|
      format.json { render json: Core::UserLookup.new(view_context) }
    end
  end

  # GET /users/new
  def new
    @user = Core::User.new
    @user.build_person
    authorize @user
  end

  # GET /users/:id/edit
  def edit
    authorize @user
  end

  # GET /users/:id/
  def show
    authorize @user
    redirect_to core_edit_user_path(@user) if @user.person == nil
  end

  # GET /users/:id/send_invite
  def send_invite
    @user.invite!(current_core_user)
    redirect_to core_user_path(@user)
  end

  # POST /users
  def create
    @user = Core::User.new(user_params)
    authorize @user
    @user.password = SecureRandom.hex(5)
    @user.password_confirmation = @user.password

    if @user.valid?
      @user.skip_confirmation!
      @user.skip_invitation= true
      @user.save
      redirect_to core_user_path(@user)
    else
      render :new
    end
  end

  # PATCH /users/:id
  # PUT /users/:id
  def update
    authorize @user
    if @user.update_attributes(user_params)
      redirect_to core_user_path(@user)
    else
      render :edit
    end
  end

  private
  def set_user
    @user = Core::User.friendly.find(params[:id])
  end

  def user_params
    params.require(:core_user).permit(
      :username, :nickname, :company,
      :department, :division, :start_of_day, :end_of_day,
      :email, :password, :role_id,

      person_attributes:
        [:_destroy, :id, :title, :first_name, :last_name, :phone, :home_phone,
          :other_phone, :email, :assistant, :asst_phone, :extension, :mobile,
          :birthdate
        ]
    )
  end
end
