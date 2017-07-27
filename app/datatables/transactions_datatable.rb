class TransactionsDatatable
  delegate :params, :h, :link_to, to: :@view
  
  #:date, :amount, :creditor, :debtor, :account, :standing_order, :item_id, :reference
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Transaction.count,
      iTotalDisplayRecords: transactions.total_entries,
      aaData: data
    }
  end

private
#:date, :amount, :creditor, :debtor, :account, :standing_order, :item_id, :reference
  def data
    #data = synchronize_transaction
    data = Array.new
    #"0" => "id", "1" => "item_id", "2" => "reference", "3" => "date", "4" => "amount", "5" => "creditor", "6" => "debtor", "7" => "account", "8" => "standing_order"
    transactions.all.order(:date).each_with_index do |transaction, index|
      row = [
        link_to(transaction.id, transaction),
        Item.find(transaction.item_id).name,
        transaction.reference,
        transaction.date,
        transaction.amount,
        transaction.creditor,
        transaction.debtor,
        transaction.account,
        transaction.standing_order
      ]
      data.push(row)
    end
    return data
  end
  
  def synchronize_transaction
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
 
  def transactions
    @transactions ||= fetch_transactions
  end

  def fetch_transactions
    transactions = Transaction.order("#{sort_column} #{sort_direction}")
    transactions = transactions.page(page).per_page(per_page)
    if params[:sSearch].present?
      #search globally (in every column) -> 'OR'
      where_clause = ""
      get_columns.each_with_index do |column, index|  #key = "0", value = "order_id"
        if params["bSearchable_"+column[0]] == "true" and Transaction.column_names.include? column[1]
          if index == 0
            where_clause = column[1] + " like :search"
            puts where_clause
          else
            where_clause = where_clause + " OR " + column[1] + " like :search"
          end
        end
        puts where_clause
      end
      
      transactions = transactions.where(where_clause, search: "%#{params[:sSearch]}%")
    else
      #search in specific column(s) -> 'AND'
      params.each do |param|   
        if param.start_with?("sSearch_")
          column_no = param[-1]           #sSearch_0 -> 0
          if params["bSearchable_"+column_no] == "true" and Transaction.column_names.include? get_columns[column_no]
            if params[param].length > 0
              where_clause = get_columns[column_no].to_s + " like :search"
              transactions = transactions.where(where_clause, search: "%#{params[param]}%")      
            end
          end
        end
      end
    end
    #return collected items
    transactions
  end
  #:date, :amount, :creditor, :debtor, :account, :standing_order, :item_id, :reference
  def get_columns
    columns = Hash.new
    columns = {"0" => "id", "1" => "item_id", "2" => "reference", "3" => "date", "4" => "amount", "5" => "creditor", "6" => "debtor", "7" => "account", "8" => "standing_order"}
    return columns
  end

  def page
    if params[:iDisplayStart].to_i > 0
      return params[:iDisplayStart].to_i/per_page + 1
    else
      return 1
    end
  end

  def per_page
    #params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    if params[:iDisplayLength].to_i < 0
      return Transaction.count
     else
      return params[:iDisplayLength].to_i
    end
  end

  def sort_column
    columns = %w[date id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end