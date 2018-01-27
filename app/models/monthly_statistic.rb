class MonthlyStatistic < ApplicationRecord
  belongs_to :item, optional: true
  
  def get_pie_data
    data = Array.new   
    if start_date.present?
      @chart = MonthlyStatistic.where('period BETWEEN ? AND ?', start_date, end_date).joins(:item)
      @expenses_pie = @chart.where('actual_value < 0').group(:name).sum(:actual_value)                    
      @expenses_pie.find_all do |item|
        actual_value = item[1].to_f*-1
        row = [item[0], actual_value]
        data.push(row)
      end
    end
    get_pie_data = data
  end
  
  def self.get_salaries
    @statistics = MonthlyStatistic.all.order(period: :asc)
    key_words = Item.where(:name => 'Nettogehalt').first.key_words.split("|")
    
    @month_dates = Hash.new
    key_words.each_with_index do |key_word, index|
      @salaries = @statistics.where('match_value LIKE ?', '%' + key_word + '%') 
      @salaries.find_each.with_index do |statistic, index|
        @month_date = Hash.new
        month_name = statistic.period.beginning_of_month.next_month.strftime("%B %Y").to_s
        transaction_id = statistic.id
        start_date = MonthlyStatistic.find(transaction_id).period
        if index +1 < @salaries.size
          puts @salaries[index+1].period.to_s
          end_date = @salaries[index+1].period-1 #Date.current.end_of_month
        else
          end_date = Date.current.end_of_month
        end
        @month_date = {"index" => index, "month" => month_name, "start_date" => start_date, "end_date" => end_date, "id" => transaction_id}
        @month_dates[transaction_id.to_s] = @month_date
      end
    end
    puts @month_dates
    return @month_dates
  end
 
  def self.get_date_of_last_income
    salaries = get_salaries
    if salaries.values[salaries.size-1].present?
      result = salaries.values[salaries.size-1]
    end
    return result    
  end
  
  def self.get_date_of_first_income
    salaries = get_salaries
    result = Date.current.beginning_of_month
    if salaries.values[0].present?
      result = salaries.values[0]
    end
    return result    
  end
  
  def self.get_expenses_for_month(id)
    date_range_month = get_start_end_date_for_month(id)
    return get_expenses(date_range_month["start_date"], date_range_month["end_date"])
  end
  
  def self.get_income_for_month(id)
    date_range_month = get_start_end_date_for_month(id)
    return get_income(date_range_month["start_date"], date_range_month["end_date"])
  end
  
  def self.get_balance_for_month(id)
    return get_income_for_month(id) + get_expenses_for_month(id)
  end
  
  def self.get_start_end_date_for_month(id)
    result = Hash.new
    salary = MonthlyStatistic.get_salaries[id]
    result["start_date"] = salary["start_date"].to_s
    result["end_date"]  = salary["end_date"].to_s
    return result
  end
  #@transactions.where('actual_value < 0 and budget = false and internal_transaction =false').sum(:actual_value) 
  def self.get_expenses(start_date, end_date)
    expenses = collect_monthly_expenses_clean(start_date, end_date).sum(:actual_value)
    #transactions.where('actual_value < 0 and (internal_transaction = false or savings = true) and reserve = false ').or(transactions.where('actual_value < 0 and reserve = true and reserve_release = false and reserve_payment = false')).sum(:actual_value)
    #reserves = transactions.where('actual_value < 0 and reserve = true and reserve_release = false').sum(:actual_value)
    return expenses #+ reserves
  end
  
  #@transactions.where('actual_value > 0 And reserve = false and budget = false and savings = false and internal_transaction =false'
  def self.get_income(start_date, end_date)
    return get_statistics_between(start_date, end_date).where('actual_value > 0 And reserve = false and (budget = false or savings_id <> 4) and internal_transaction =false').sum(:actual_value)
  end
  
  def self.get_balance(start_date, end_date)
    return get_income(start_date, end_date) + get_expenses(start_date, end_date)
  end
  
  def self.get_statistics_between(start_date, end_date)
    return MonthlyStatistic.where('period BETWEEN ? AND ?', start_date, end_date).joins(:item)
  end
  
  def self.get_expenses_grouped(start_date, end_date, group_by)
    #transactions = get_statistics_between(start_date, end_date)
    #expenses = transactions.where('actual_value < 0 and (internal_transaction = false or savings = true) and reserve = false').or(transactions.where('actual_value < 0 and reserve = true and (reserve_release = false and reserve_payment = false)'))
    #reserves = transactions.where('actual_value < 0 and reserve = true')
    #grouped_expenses = expenses
    #MonthlyStatistic.where('actual_value < 0 and monthly_statistics.id In (Select * from monthly_statistics where internal_transaction = false and period BETWEEN ? AND ?) UNION (Select * from monthly_statistics where reserve = false and period BETWEEN ? AND ?)', start_date, end_date, start_date, end_date).joins(:item) #expenses.merge(reserves)
    return collect_monthly_expenses_clean(start_date, end_date).group(group_by).order('sum_actual_value ASC').sum(:actual_value)
    #return get_statistics_between(start_date, end_date).where('actual_value < 0 and internal_transaction = false').group(:name).order('sum_actual_value ASC').sum(:actual_value)
    ##.where('actual_value < 0 and internal_transaction =false').group(group_by).order('sum_actual_value ASC').sum(:actual_value)
  end

  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      MontlyStatistic.create! row.to_hash
    end
  end
  
  #private
  
    def self.collect_monthly_expenses_clean(start_date, end_date)
      transactions = get_statistics_between(start_date, end_date)
      return transactions.where('actual_value < 0 and (internal_transaction = false or savings_id <> 4) and reserve = false').or(transactions.where('actual_value < 0 and reserve = true and (reserve_release = false and reserve_payment = false)'))
    end
end
