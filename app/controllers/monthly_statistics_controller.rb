class MonthlyStatisticsController < ApplicationController
  before_action :set_monthly_statistic, only: [:show, :edit, :update, :destroy]

  def get_pie_data
    @data = Array.new  
    if params[:start_date].present? && params[:end_date].present?
      @chart = MonthlyStatistic.where('period BETWEEN ? AND ?', params[:start_date], params[:end_date]).joins(:item)
      @expenses_pie = @chart.where('actual_value < 0').group(:name).sum(:actual_value)                    
      @expenses_pie.find_all do |item|
        actual_value = item[1].to_f*-1
        row = [item[0], actual_value]
        @data.push(row)
      end
      render json: @data and return false
    end
  end

  
  # GET /monthly_statistics
  # GET /monthly_statistics.json
  def index
    respond_to do |format|
    format.html
    format.json { render json: MonthlyStatisticsDatatable.new(view_context) }
    end
  end

  # GET /monthly_statistics/1
  # GET /monthly_statistics/1.json
  def show
    @monthly_statistic = MonthlyStatistic.find(params[:id])
  end

  # GET /monthly_statistics/new
  def new
    @monthly_statistic = MonthlyStatistic.new
  end

  # GET /monthly_statistics/1/edit
  def edit
    @monthly_statistic = MonthlyStatistic.find(params[:id])
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
  
  def import
    MonthlyStatistic.import(params[:file])
    redirect_to monthly_statistics_path, notice: "Statistics data imported"
  end
  
  def delete_all
    MonthlyStatistic.delete_all
    redirect_to monthly_statistics_path, notice: "All items deleted"    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monthly_statistic
      @monthly_statistic = MonthlyStatistic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monthly_statistic_params
      params.require(:monthly_statistic).permit(:period, :planned_value, :actual_value, :item_id, :hibiscus_sync_id, :match_confidence, :match_type, :match_value, :account_id, :internal_transaction, :reserve_payment, :reserve_release)
    end

end
