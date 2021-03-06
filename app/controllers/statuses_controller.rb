class StatusesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.order('created_at desc').all
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show

  end

  # GET /statuses/new
  def new
    @status = Status.new
    @status.build_document
  end

  # GET /statuses/1/edit
  def edit
    @status = current_user.statuses.find(params[:id])
    @document = @status.document
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params)
    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    @status = current_user.statuses.find(params[:id])
    @document = @status.document
    if params[:status] && params[:status].has_key?(:user_id)
      params[:status].delete(:user_id)
    end
    respond_to do |format|
      if @status.update_attributes(status_params) && @document && @document.update_attributes(status_params[:document_attributes]) 
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:id, :user_id, :content, :first_name, :last_name, :profile_name, :full_name, document_attributes: [:attachment])
    end
end
