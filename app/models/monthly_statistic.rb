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
        #@month_date['month'] = 
        #@month_date['id'] = 
        #@month_dates.push(@month_date)
      end
    end
    puts @month_dates
    return @month_dates
  end
 
  def self.get_date_of_last_income
    salaries = get_salaries
    result = Date.current.end_of_month
    
    if salaries[salaries.size].present?
      #statistic_id = salaries.last['id'].to_i
      #monthly_statistic = MonthlyStatistic.find(statistic_id)
      result = salaries[salaries.size]["start_date"] #monthly_statistic.period
    end
    
    return result    
  end
  
  def self.get_date_of_first_income
    salaries = get_salaries
    result = Date.current.beginning_of_month
    
    if salaries.values[0].present?
      #statistic_id = salaries[0]["start_date"].to_i
      #monthly_statistic = MonthlyStatistic.find(statistic_id)
      result = salaries.values[0]["start_date"] #monthly_statistic.period
    end
    
    return result    
  end
  
  
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      MontlyStatistic.create! row.to_hash
    end
  end
end
