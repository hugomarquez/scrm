class Core::NotesController < ApplicationController
  before_action :set_note, only:[:edit, :show, :update, :destroy]

  # GET /notes/new
  def new
    @note = Core::Note.new(created_by: current_core_user)
    authorize @note
  end

  # GET /notes/:id/edit
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

  # GET /notes/:id
  def show
    authorize @note
  end

  # POST /notes
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

  # PATCH /notes/:id
  # PUT /notes/:id
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

  # DELETE /projects/:id
  def destroy
    authorize @note
    if @note.destroy
      redirect_back fallback_location: core_root_path
    end
  end

  private

  def set_note
    @note = Core::Note.includes(:noteable).friendly.find(params[:id])
  end

  def note_params
    params.require(:core_note).permit(
      :private, :title, :body, :noteable_type, :noteable_id, :related_to
    )
  end

  def params_without_virtual_attributes
    note_params.select do |p|
      p.exclude?('noteable_id') and p.exclude?('related_to')
    end
  end
end
