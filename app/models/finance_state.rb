class FinanceState < ApplicationRecord
  belongs_to :account
  
  def self.synchronize
    
    if FinanceState.last.hibiscus_id.present?
      @id_last_synchronization = FinanceState.last.hibiscus_id
    else
      @id_last_synchronization = "1"
    end
    puts "LAST SYNCHRONIZATION ID (FINANCE STATE): " + @id_last_synchronization
    puts "HIBISCUS TRANSACTION ID: " + 
    
    if @id_last_synchronization != HibiscusTransaction.last.id
      HibiscusTransaction.find_each(start: @id_last_synchronization) do |transaction|
             
        transaction.id,
        transaction.zweck,
        transaction.zweck2,
        transaction.zweck3,
        transaction.valuta,
        transaction.betrag,
        transaction.konto_id,
        transaction.empfaenger_name,
        transaction.art
      end
    else
          
    end
    data = Array.new
    HibiscusTransaction.all.order(valuta: :desc).each_with_index do |transaction, index|
      row = [
        transaction.id,
        transaction.zweck,
        transaction.zweck2,
        transaction.zweck3,
        transaction.valuta,
        transaction.betrag,
        transaction.konto_id,
        transaction.empfaenger_name,
        transaction.art
      ]
      data.push(row)
    end
    return data
  end
   
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      FinanceState.create! row.to_hash
    end
  end
end
