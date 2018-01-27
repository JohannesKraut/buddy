class SavingsController < ApplicationController
  before_action :set_saving, only: [:show, :edit, :update, :destroy]

  # GET /savings
  # GET /savings.json
  def index
    #@savings = Saving.all
    respond_to do |format|
    format.html
    format.json { render json: SavingsDatatable.new(view_context) }
    end
  end

  # GET /savings/1
  # GET /savings/1.json
  def show
  end

  # GET /savings/new
  def new
    @saving = Saving.new
  end

  # GET /savings/1/edit
  def edit
  end

  # POST /savings
  # POST /savings.json
  def create
    @saving = Saving.new(saving_params)

    respond_to do |format|
      if @saving.save
        format.html { redirect_to @saving, notice: 'Saving was successfully created.' }
        format.json { render :show, status: :created, location: @saving }
      else
        format.html { render :new }
        format.json { render json: @saving.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /savings/1
  # PATCH/PUT /savings/1.json
  def update
    respond_to do |format|
      if @saving.update(saving_params)
        format.html { redirect_to @saving, notice: 'Saving was successfully updated.' }
        format.json { render :show, status: :ok, location: @saving }
      else
        format.html { render :edit }
        format.json { render json: @saving.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /savings/1
  # DELETE /savings/1.json
  def destroy
    @saving.destroy
    respond_to do |format|
      format.html { redirect_to savings_url, notice: 'Saving was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saving
      @saving = Saving.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def saving_params
      params.require(:saving).permit(:name, :description, :duration)
    end
end
