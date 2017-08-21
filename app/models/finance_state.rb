class FinanceState < ApplicationRecord
  belongs_to :account
  
  def self.synchronize
        
    Account.all.each do |account|
      @current_account = account.id
      puts "CURRENT ACCOUNT: " + @current_account.to_s
      
      if FinanceState.where(:account_id => @current_account).last.present? 
          @id_last_synchronization = FinanceState.where(:account_id => @current_account).last.hibiscus_sync_id
      else
          @id_last_synchronization = "1"
      end
      
      @id_last_synchronization_hibiscus = HibiscusTransaction.where(:konto_id => @current_account).last.id
      
      puts "LAST SYNCHRONIZATION ID (FINANCE STATE): " + @id_last_synchronization.to_s
      puts "HIBISCUS TRANSACTION ID: " + @id_last_synchronization_hibiscus.to_s
      
      if @id_last_synchronization != @id_last_synchronization_hibiscus
      
        HibiscusTransaction.where(:konto_id => @current_account).find_each(start: @id_last_synchronization) do |transaction|
          puts "CURRENT HIBISCUS ID: " + transaction.id.to_s
          Item.all.each do |item|
            #puts "CURRENT ITEM: " + item.id.to_s
            @found = false
            
            if item.key_words.present?
              key_words_array = item.key_words.split("|")
              key_words_array.each do |key_word|
                
                puts "CURRENT ITEMS KEY WORDS: " + key_word
                puts "CURRENT TRANSACTION ZWECK: " + transaction.zweck
                puts "CURRENT TRANSACTION ZWECK2: " + transaction.zweck2
                puts "CURRENT TRANSACTION ZWECK3: " + transaction.zweck3
                
                @key_words = /#{key_word}/im
                if transaction.zweck =~ @key_words
                  puts "HEEERE 1 " + transaction.zweck
                  @found = true
                end
                
                if transaction.zweck2 =~ @key_words
                  puts "HEEERE 2 " + transaction.zweck2
                  @found = true
                end
                
                if transaction.zweck3 =~ @key_words
                  puts "HEEERE 3 " + transaction.zweck3
                  @found = true
                end
                
                puts "CREATE MONTHLY STATISTIC? " + @found.to_s
                if @found == true
                  MonthlyStatistic.create(:period => transaction.valuta, :planned_value => item.amount_calculated, :actual_value => transaction.betrag, :item_id => item.id, :hibiscus_sync_id => transaction.id)
                  @last_synchronized = transaction.valuta
                  @balance = transaction.saldo
                  @hibiscus_id = transaction.id
                  @found = false
                end
              end

              #  /#{place}/
              #"string" =~ /regex/
              #"string" =~ /regex/
                       
              #if @key_words.include? transaction.zweck or item.key_words.include? transaction.zweck2 or item.key_words.include? transaction.zweck3 
                #puts "HEEERE " + transaction.zweck + transaction.zweck2 + transaction.zweck3
              #end
            end
          
          end #end item
        #transaction.id,
        #transaction.zweck,
        #transaction.zweck2,
        #transaction.zweck3,
        #transaction.valuta,
        #transaction.betrag,
        #transaction.konto_id,
        #transaction.empfaenger_name,
        #transaction.art
        end #end hibsicus_transaction
        if @last_synchronized.present?        
          FinanceState.create(:period => @last_synchronized, :hibiscus_sync_id => @hibiscus_id, :balance => @balance, :account_id => @current_account)
          @last_synchronized = nil
          @balance = nil
          @hibiscus_id = nil
        end
      
      else
        puts "Finance state up to date. No synchronization performed."
      end
    end #end account
    #HibiscusTransaction.all.order(valuta: :desc).each_with_index do |transaction, index|
  end
   
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      FinanceState.create! row.to_hash
    end
  end
end
