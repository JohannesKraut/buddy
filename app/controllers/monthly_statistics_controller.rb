class MonthlyStatisticsController < ApplicationController
  before_action :set_monthly_statistic, only: [:show, :edit, :update, :destroy]

  # GET /monthly_statistics
  # GET /monthly_statistics.json
  def index
    @monthly_statistics = MonthlyStatistic.all
  end

  # GET /monthly_statistics/1
  # GET /monthly_statistics/1.json
  def show
  end

  # GET /monthly_statistics/new
  def new
    @monthly_statistic = MonthlyStatistic.new
  end

  # GET /monthly_statistics/1/edit
  def edit
  end

  # POST /monthly_statistics
  # POST /monthly_statistics.json
  def create
    @monthly_statistic = MonthlyStatistic.new(monthly_statistic_params)

    respond_to do |format|
      if @monthly_statistic.save
        format.html { redirect_to @monthly_statistic, notice: 'Monthly statistic was successfully created.' }
        format.json { render :show, status: :created, location: @monthly_statistic }
      else
        format.html { render :new }
        format.json { render json: @monthly_statistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monthly_statistics/1
  # PATCH/PUT /monthly_statistics/1.json
  def update
    respond_to do |format|
      if @monthly_statistic.update(monthly_statistic_params)
        format.html { redirect_to @monthly_statistic, notice: 'Monthly statistic was successfully updated.' }
        format.json { render :show, status: :ok, location: @monthly_statistic }
      else
        format.html { render :edit }
        format.json { render json: @monthly_statistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monthly_statistics/1
  # DELETE /monthly_statistics/1.json
  def destroy
    @monthly_statistic.destroy
    respond_to do |format|
      format.html { redirect_to monthly_statistics_url, notice: 'Monthly statistic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monthly_statistic
      @monthly_statistic = MonthlyStatistic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monthly_statistic_params
      params.require(:monthly_statistic).permit(:period, :planned_value, :actual_value, :item_id)
    end
end
