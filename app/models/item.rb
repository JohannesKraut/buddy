class Item < ApplicationRecord
  belongs_to :category
  belongs_to :interval
  belongs_to :account, optional: true
  belongs_to :saving, optional: true
  #belongs_to :id, :class_name => 'Item'
  has_many :item_id, :class_name => 'Item', :foreign_key => 'id'
  
  def calculate_planned_value
    if id.present?
      @item = Item.find(id)
      @interval = Interval.find(interval_id)
      @multiplier = Rational(@interval.numerator * @interval.denominator)
      
      calculate_planned_value = @multiplier * total_amount      
    end

    #@item.update(amount_calculated: calculate_planned_value)
    #amount_calculated = calculate_planned_value
  end
 
  
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      Item.create! row.to_hash
    end
  end
    
end
