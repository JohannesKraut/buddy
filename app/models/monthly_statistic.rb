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
  
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      MontlyStatistic.create! row.to_hash
    end
  end
end
