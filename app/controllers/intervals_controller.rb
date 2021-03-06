class IntervalsController < ApplicationController
  before_action :set_interval, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  
  # GET /intervals
  # GET /intervals.json
  def index
    respond_to do |format|
    format.html
    format.json { render json: IntervalsDatatable.new(view_context) }
    end
  end

  # GET /intervals/1
  # GET /intervals/1.json
  def show
    Interval.find(params[:id])
  end

  # GET /intervals/new
  def new
    @interval = Interval.new
  end

  # GET /intervals/1/edit
  def edit
    Interval.find(params[:id])
  end

  # POST /intervals
  # POST /intervals.json
  def create
    @interval = Interval.new(interval_params)

    respond_to do |format|
      if @interval.save
        format.html { redirect_to @interval, notice: 'Interval was successfully created.' }
        format.json { render :show, status: :created, location: @interval }
      else
        format.html { render :new }
        format.json { render json: @interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /intervals/1
  # PATCH/PUT /intervals/1.json
  def update
    respond_to do |format|
      if @interval.update(interval_params)
        format.html { redirect_to @interval, notice: 'Interval was successfully updated.' }
        format.json { render :show, status: :ok, location: @interval }
      else
        format.html { render :edit }
        format.json { render json: @interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intervals/1
  # DELETE /intervals/1.json
  def destroy
    @interval.destroy
    respond_to do |format|
      format.html { redirect_to intervals_url, notice: 'Interval was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def import
    Interval.import(params[:file])
    redirect_to intervals_path, notice: "Item data imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interval
      @interval = Interval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interval_params
      params.require(:interval).permit(:numerator, :denominator, :description, :name)
    end
end
