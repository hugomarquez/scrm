class Core::UsersController < ApplicationController
  before_action :set_user, only:[:edit, :show, :update, :send_invite]

  #Metodo index. Asigna la respuesta a la respuesta de la llamada
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

  #Metodo new. Crea un nuevo usuario y la contruye.
  def new
    @user = Core::User.new
    @user.build_person
    authorize @user
  end

  #Metodo edit. Comprueba los privilegios.
  def edit
    authorize @user
  end

  #Metodo show. Comprueba los privilegios y te redirige a core_edit_user_path si no hay usuario
  def show
    authorize @user
    redirect_to core_edit_user_path(@user) if @user.person == nil
  end

  #Metodo send_invite. Crea una invitacion a nombre del usuario y te redirige a core_user_path
  def send_invite
    @user.invite!(current_core_user)
    redirect_to core_user_path(@user)
  end

  #Metodo create. Crea un nuevo usuario y le asigna una contraseña segura
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

  #Metodo update. Te redirige a la pagina para modificar datos.
  def update
    authorize @user
    if @user.update_attributes(user_params)
      redirect_to core_user_path(@user)
    else
      render :edit
    end
  end

  private
  #Metodo set_user. Le asigna un usuario a @user por su id
  def set_user
    @user = Core::User.friendly.find(params[:id])
  end

  #Metodo user_params. Se le asigna los valores requeridos y permitidos
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
