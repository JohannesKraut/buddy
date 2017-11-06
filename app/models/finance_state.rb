class FinanceState < ApplicationRecord
  belongs_to :account
  
  def self.synchronize
    
    @counter = 0
    #HibiscusTransaction.all.order(valuta: :desc).each_with_index do |transaction, index|
    Account.all.order(hibiscus_account_id: :asc).each do |account|
      @current_account = account.hibiscus_account_id
      logger.debug "CURRENT ACCOUNT: " + @current_account.to_s
      #"New article: #{@article.attributes.inspect}"
      #puts "CURRENT ACCOUNT: " + @current_account.to_s
      
      if FinanceState.where(:account_id => account.id).last.present? 
          @id_last_synchronization = FinanceState.where(:account_id => account.id).last.hibiscus_sync_id
      else
          @id_last_synchronization = "1"
      end
      
      @id_last_synchronization_hibiscus = HibiscusTransaction.where(:konto_id => @current_account).order(id: :asc).last.id
      
      logger.debug "LAST SYNCHRONIZATION ID (FINANCE STATE): " + @id_last_synchronization.to_s
      logger.debug "HIBISCUS TRANSACTION ID: " + @id_last_synchronization_hibiscus.to_s
      
      if @id_last_synchronization != @id_last_synchronization_hibiscus
      
        HibiscusTransaction.where(:konto_id => @current_account).order(id: :asc).find_each(start: @id_last_synchronization) do |transaction|
          @counter += 1
          
          logger.debug "CURRENT HIBISCUS ID: " + transaction.id.to_s
          
          @hibiscus_sync_id = transaction.id
          @period = transaction.valuta.to_date
          @actual_value = transaction.betrag.to_f
          @item_id = 34
          @planned_value = Item.find(@item_id).amount_calculated
          @match_confidence = nil
          @match_type = nil
          @match_value = nil

          #Item.all.each do |item|
          Item.where(:active => true).find_each do |item|
            #puts "CURRENT ITEM: " + item.id.to_s          
            @match = match_item_to_transaction(account, item, transaction)
        
            if @match.present?
              @match_confidence = @match["confidence"].to_f 
              @match_type = @match["match_type"]
              @match_value = @match["match_value"]
              if @match_value.present?
                #@match["match_type"] != "default"
                logger.debug "USING DEFAULT VALUE"
                @planned_value = item.amount_calculated
                @item_id = item.id
                break   
              end
                    
            end                      
          end   #end item
          
          logger.debug  "CREATE MONTHLY STATISTIC"
          MonthlyStatistic.create(:period => @period, :planned_value => @planned_value, :actual_value => @actual_value, :item_id => @item_id, :hibiscus_sync_id => @hibiscus_sync_id, :match_confidence => @match_confidence, :match_type => @match_type, :match_value => @match_value, :account_id => account.id)
          @last_synchronized = transaction.valuta
          @balance = transaction.saldo
          @hibiscus_id = transaction.id
          
        end   #end hibsicus_transaction
        
        
        if @last_synchronized.present?  
          logger.debug "CREATE FINANCE STATE"      
          FinanceState.create(:period => @last_synchronized, :hibiscus_sync_id => @hibiscus_id, :balance => @balance, :account_id => account.id)
          @last_synchronized = nil
          @balance = nil
          @hibiscus_id = nil
        end
      
      else
        logger.debug "Finance state up to date. No synchronization performed."
      end
    end #end account
    logger.debug "Total transaction: " + @counter.to_s
    #HibiscusTransaction.all.order(valuta: :desc).each_with_index do |transaction, index|
  end
  
  def self.match_item_to_transaction(account, item, transaction)
    
    @return = Hash.new
    @return["match_type"] = nil
    @return["match_value"] = nil
    @return["confidence"] = 0
    
    # try to match via external account
    if item.external_account.present?
      @account_found = find_by_account(item.external_account.split("|"), transaction)
      if @account_found.present?
        if item.reserve == false
          @return["match_type"] = "external_account"
          @return["match_value"] = @account_found
          @return["confidence"] = @return["confidence"].to_f + 0.5
          logger.debug "TRANSACTION FOUND BY EXTERNAL ACCOUNT " + @account_found
        end
        #return @return
      end
    end
    
    # try to match via key words
    if item.key_words.present?
      @keyword_found = find_by_keyword(item.key_words.split("|"), transaction)
      if @keyword_found.present?
        @return["match_type"] = "key_word"
        @return["match_value"] = @keyword_found
        @return["confidence"] = @return["confidence"].to_f + 0.5
        logger.debug "TRANSACTION FOUND BY KEY WORD " + @keyword_found.to_s
        #return @return        
      end
    end
    
    # try to match via item name
    if item.name.present?
      @keyword_found = find_by_name(item.name, transaction)
      if @keyword_found.present?
        @return["match_type"] = "item_name"
        @return["match_value"] = @keyword_found
        @return["confidence"] = @return["confidence"].to_f + 0.5
        logger.debug "TRANSACTION FOUND BY NAME " + @keyword_found.to_s
        #return @return        
      end
    end
    
    # match via (internal/default) account
    if item.account_id.present?
      if account.id == item.account_id
        #if transaction.empfaenger_konto == Account.find(item.account_id).iban
        @confidence = @return["confidence"].to_f
        if @confidence == 0 && item.reserve == false
          @return["match_type"] = "default"
          @return["match_value"] = item.account_id        
          logger.debug "TRANSACTION FOUND BY ACCOUNT " + account.description
        end
      end
    end
    return @return
  end
  
  def self.find_by_account(accounts_array, transaction)
    
    accounts_array.each do |account|
      
      @account = account.downcase
      logger.debug "FIND BY ACCOUNT: " + account
      #@accounts = /#{account}/im
      #if transaction.empfaenger_konto =~ @accounts
      if transaction.empfaenger_konto.present?
        if transaction.empfaenger_konto.downcase.include? @account
          puts "Account " + account
          return account
        end        
      end
    end
    
    return nil    
    
  end
  
  def self.find_by_keyword(key_words_array, transaction)
    
    key_words_array.each do |key_word|
                
      logger.debug "CURRENT ITEMS KEY WORDS: " + key_word
      logger.debug "CURRENT TRANSACTION ZWECK: " + transaction.zweck.to_s
      logger.debug "CURRENT TRANSACTION ZWECK2: " + transaction.zweck2.to_s
      logger.debug "CURRENT TRANSACTION ZWECK3: " + transaction.zweck3.to_s
      logger.debug "CURRENT TRANSACTION ART: " + transaction.art.to_s
      
      #@key_words = /#{key_word}/im
      @key_words = key_word.delete(' ').downcase
      #if transaction.zweck.match(@key_words)
      if transaction.zweck.to_s.delete(' ').downcase.include? @key_words
      #if transaction.zweck =~ @key_words
        logger.debug "Zweck " + transaction.zweck.to_s
        return key_word
      end
      
      if transaction.zweck2.to_s.delete(' ').downcase.include? @key_words
        logger.debug "Zweck2 " + transaction.zweck2.to_s
        return key_word
      end
      
      if transaction.zweck3.to_s.delete(' ').downcase.include? @key_words
        logger.debug "Zweck3 " + transaction.zweck3.to_s
        return key_word
      end
      
      if transaction.art.to_s.delete(' ').downcase.include? @key_words
        logger.debug "Art " + transaction.art.to_s
        return key_word
      end
      
    end
    
    return nil

  end
  
  
  def self.find_by_name(item_name, transaction)
    
      logger.debug "CURRENT TRANSACTION ZWECK: " + transaction.zweck.to_s
      logger.debug "CURRENT TRANSACTION ZWECK2: " + transaction.zweck2.to_s
      logger.debug "CURRENT TRANSACTION ZWECK3: " + transaction.zweck3.to_s
      
      #@key_words = /#{key_word}/im
      @key_words = item_name.delete(' ').downcase
      #if transaction.zweck.match(@key_words)
      if transaction.zweck.to_s.delete(' ').downcase.include? @key_words
      #if transaction.zweck =~ @key_words
        logger.debug "Zweck " + transaction.zweck.to_s
        return @key_words
      end
      
      if transaction.zweck2.to_s.delete(' ').downcase.include? @key_words
        logger.debug "Zweck2 " + transaction.zweck2.to_s
        return @key_words
      end
      
      if transaction.zweck3.to_s.delete(' ').downcase.include? @key_words
        logger.debug "Zweck3 " + transaction.zweck3.to_s
        return @key_words
      end
    
    return nil    
  end
  
  require 'csv'
  #uses import method of referenced class CSV
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
      FinanceState.create! row.to_hash
    end
  end
end
