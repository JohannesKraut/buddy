class FinanceStatesDatatable
  delegate :params, :h, :link_to, to: :@view
    
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: FinanceState.count,
      iTotalDisplayRecords: finance_states.total_entries,
      aaData: data
    }
  end

private

  def data
    data = Array.new
    finance_states.all.order(:period).each_with_index do |finance_state, index|
      row = [
        finance_state.period,
        finance_state.hibiscus_sync_id,
        finance_state.balance,
        finance_state.account_id
      ]
      data.push(row)
    end
    return data
  end
 
  def finance_states
    @finance_states ||= fetch_finance_states
  end

  def fetch_finance_states
    finance_states = FinanceState.order("#{sort_column} #{sort_direction}")
    finance_states = finance_states.page(page).per_page(per_page)
    if params[:sSearch].present?
      #search globally (in every column) -> 'OR'
      where_clause = ""
      get_columns.each_with_index do |column, index|  #key = "0", value = "order_id"
        if params["bSearchable_"+column[0]] == "true" and FinanceState.column_names.include? column[1]
          if index == 0
            where_clause = column[1] + " like :search"
            puts where_clause
          else
            where_clause = where_clause + " OR " + column[1] + " like :search"
          end
        end
        puts where_clause
      end
      
      finance_states = finance_states.where(where_clause, search: "%#{params[:sSearch]}%")
    else
      #search in specific column(s) -> 'AND'
      params.each do |param|   
        if param.start_with?("sSearch_")
          column_no = param[-1]           #sSearch_0 -> 0
          if params["bSearchable_"+column_no] == "true" and FinanceState.column_names.include? get_columns[column_no]
            if params[param].length > 0
              where_clause = get_columns[column_no].to_s + " like :search"
              finance_states = finance_states.where(where_clause, search: "%#{params[param]}%")      
            end
          end
        end
      end
    end
    #return collected items
    finance_states
  end
  
  def get_columns
    #return @columns
    columns = Hash.new
    columns = {"0" => "period", "1" => "hibiscus_sync_id", "2" => "balance", "3" => "account_id"}
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
      return FinanceState.count
     else
      return params[:iDisplayLength].to_i
    end
  end

  def sort_column
    columns = %w[period]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end