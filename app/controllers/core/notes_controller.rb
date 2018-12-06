#Declaracion de la clase NotesController
class Core::NotesController < ApplicationController
  before_action :set_note, only:[:edit, :show, :update, :destroy]

  #Metodo new. Le asigna un valor a @note y se llama la funcion authorize para comprobar que el usuario tenga 
  #los permisos necesarios. Devuelve true si cuenta con la autorizacion, de lo contrario lanza una excepcion
  def new
    @note = Core::Note.new(created_by: current_core_user)
    authorize @note
  end

  #Metodo edit. Comprueba el nivel de privilegios y despues se le agrega el valor related_to dependiendo de los atributos
  def edit
    authorize @note
    if @note.noteable
      if @note.noteable_type.constantize.reflect_on_association(:person).respond_to?(:name)
        @note.related_to = @note.noteable.person.full_name
      elsif @note.noteable.attribute_names.include?("name")
        @note.related_to = @note.noteable.name
      end
    end
  end

  #Metodo show. Solamente comprueba los privilegios del usuario
  def show
    authorize @note
  end

  #Metodo create. Crea un nuevo note, le agrega el nombre del usuario creador, comprueba sus privilegios, se le asigna un id.
  #Si es valido lo guarda y te redirije a core_root_path, si no crea una respuesta nueva.
  def create
    @note = Core::Note.new(params_without_virtual_attributes)
    @note.created_by = current_core_user
    authorize @note
    @note.noteable_id = polymorphic_builder(note_params[:related_to], note_params[:noteable_type], note_params[:noteable_id])
    if @note.valid?
      @note.save
      redirect_to core_root_path
    else
      render :new
    end

  end

  #Metodo update. Checa los privilegios, le asigna unos parametros vacios y genera un nuevo id.
  #Comprueba que sea valido y lo guarda
  def update
    authorize @note
    @note.attributes = params_without_virtual_attributes
    @note.noteable_id = polymorphic_builder(note_params[:related_to], note_params[:noteable_type], note_params[:noteable_id])
    if @note.valid?
      @note.save
      redirect_to core_root_path
    else
      render :edit
    end
  end

  #Metodo destroy. Comprueba privilegios del usuario y, si se destruye el objeto te regresa a core_root_path
  def destroy
    authorize @note
    if @note.destroy
      redirect_back fallback_location: core_root_path
    end
  end

  private

  #Metodo set_note. Se le asigna un valor a @note
  def set_note
    @note = Core::Note.includes(:noteable).friendly.find(params[:id])
  end

  #Metodo note_params. Asigna los valores requeridos y permitidos en note
  def note_params
    params.require(:core_note).permit(
      :private, :title, :body, :noteable_type, :noteable_id, :related_to
    )
  end

  #Metodo params_without_virtual_attributes. Le desasigna el id y la relacion al objeto recibido.
  def params_without_virtual_attributes
    note_params.select do |p|
      p.exclude?('noteable_id') and p.exclude?('related_to')
    end
  end
end
