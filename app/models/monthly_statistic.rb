class MonthlyStatistic < ApplicationRecord
  belongs_to :item, optional: true
  
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      MontlyStatistic.create! row.to_hash
    end
  end
end
