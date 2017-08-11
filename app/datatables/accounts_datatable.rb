class AccountsDatatable
  delegate :params, :h, :link_to, to: :@view
    
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Account.count,
      iTotalDisplayRecords: accounts.total_entries,
      aaData: data
    }
  end

private

  def data
    data = Array.new
    accounts.all.order(:id).each_with_index do |account, index|
      row = [
        account.id,
        account.account_number,
        account.description,
        account.iban,
        account.bic,
        link_to('Edit', account),
        link_to('Destroy', account, method: :delete, data: { confirm: 'Are you sure?' })
      ]
      data.push(row)
    end
    return data
  end
 
  def accounts
    @accounts ||= fetch_accounts
  end

  def fetch_accounts
    accounts = Account.order("#{sort_column} #{sort_direction}")
    accounts = accounts.page(page).per_page(per_page)
    if params[:sSearch].present?
      #search globally (in every column) -> 'OR'
      where_clause = ""
      get_columns.each_with_index do |column, index|  #key = "0", value = "order_id"
        if params["bSearchable_"+column[0]] == "true" and Account.column_names.include? column[1]
          if index == 0
            where_clause = column[1] + " like :search"
            puts where_clause
          else
            where_clause = where_clause + " OR " + column[1] + " like :search"
          end
        end
        puts where_clause
      end
      
      accounts = accounts.where(where_clause, search: "%#{params[:sSearch]}%")
    else
      #search in specific column(s) -> 'AND'
      params.each do |param|   
        if param.start_with?("sSearch_")
          column_no = param[-1]           #sSearch_0 -> 0
          if params["bSearchable_"+column_no] == "true" and Account.column_names.include? get_columns[column_no]
            if params[param].length > 0
              where_clause = get_columns[column_no].to_s + " like :search"
              accounts = accounts.where(where_clause, search: "%#{params[param]}%")      
            end
          end
        end
      end
    end
    #return collected items
    accounts
  end
  
  def get_columns
    #return @columns
    columns = Hash.new
    columns = {"0" => "account_number", "1" => "description", "2" => "iban", "3" => "bic", "4" => "Edit", "5" => "Destroy"}
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
      return Account.count
     else
      return params[:iDisplayLength].to_i
    end
  end

  def sort_column
    columns = %w[id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end