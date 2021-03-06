class DashboardController < ApplicationController
  
  def get_expenses_grouped
    if params[:month].present?
      #result = Hash.new
      salary = MonthlyStatistic.get_salaries(params[:user_id])[params[:month]]
      start_date = salary["start_date"].to_s
      end_date = salary["end_date"].to_s
      #transactions = transaction_in_range(start_date, end_date)
      expenses = MonthlyStatistic.get_expenses_for_month(params[:month], params[:user_id]) #transactions.where('actual_value < 0').sum(:actual_value)
      income = MonthlyStatistic.get_income_for_month(params[:month], params[:user_id]) #transactions.where('actual_value > 0 And reserve = false and budget = false and savings = false').sum(:actual_value)
      balance = MonthlyStatistic.get_balance_for_month(params[:month], params[:user_id]) #expenses + income
      chart = MonthlyStatistic.get_expenses_grouped(start_date, end_date, params[:user_id], :name)
      #get_statistics_between(start_date, end_date).where('actual_value < 0').group(:name).order('sum_actual_value ASC').sum(:actual_value)
      result = {"data" => chart, "start_date" => start_date, "end_date" => end_date, "expenses" => expenses, "income" => income, "balance" => balance}
    end
    render json: result.to_json
  end 
  
  def transaction_in_range(start_date, end_date)
    #return MonthlyStatistic.where('period BETWEEN ? AND ?', start_date, end_date).joins(:item)
  end
  
  def dashboard
  end
  
  def index
  end
end
