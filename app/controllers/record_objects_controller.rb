class RecordObjectsController < ApplicationController
  before_action :set_record_object, only: [:show, :edit, :update, :destroy]

  # GET /record_objects
  # GET /record_objects.json
  def index
    @record_objects = RecordObject.all
  end

  # GET /record_objects/1
  # GET /record_objects/1.json
  def show
  end

  # GET /record_objects/new
  def new
    @record_object = RecordObject.new
  end

  # GET /record_objects/1/edit
  def edit
  end

  # POST /record_objects
  # POST /record_objects.json
  def create
    @record_object = RecordObject.new(record_object_params)

    respond_to do |format|
      if @record_object.save
        format.html { redirect_to @record_object, notice: 'RecordObject was successfully created.' }
        format.json { render :show, status: :created, location: @record_object }
      else
        format.html { render :new }
        format.json { render json: @record_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /record_objects/1
  # PATCH/PUT /record_objects/1.json
  def update
    respond_to do |format|
      if @record_object.update(record_object_params)
        format.html { redirect_to @record_object, notice: 'RecordObject was successfully updated.' }
        format.json { render :show, status: :ok, location: @record_object }
      else
        format.html { render :edit }
        format.json { render json: @record_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /record_objects/1
  # DELETE /record_objects/1.json
  def destroy
    @record_object.destroy
    respond_to do |format|
      format.html { redirect_to record_objects_url, notice: 'RecordObject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record_object
      @record_object = RecordObject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_object_params
      params.require(:record_object).permit(:label, :description, :attribution, :license, :naId, image_attributes: [:title, :description, :image, :id, :_destroy])
    end
end
