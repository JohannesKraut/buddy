class Account < ApplicationRecord
  has_many :items
  belongs_to :user
  has_many :transactions, :class_name => 'Transaction'
  has_many :monthly_statistics, :through => :transactions
  
  validates :user, presence: true
  resourcify

  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      Account.create! row.to_hash
    end
  end
end
