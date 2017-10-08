class Account < ApplicationRecord
  has_many :items

  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      Account.create! row.to_hash
    end
  end
end
