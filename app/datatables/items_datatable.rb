class ItemsDatatable
  delegate :params, :h, :link_to, to: :@view
  
  #define scope for db-lookup
  #scope :featured, -> { where(:featured => true) }
  #scope :by_degree, -> degree { where(:degree => degree) }
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Item.count,
      iTotalDisplayRecords: items.total_entries,
      aaData: data
    }
  end

private

  def data
    data = Array.new
    items.all.order(:order_id).each_with_index do |item, index|
      if index == 0 then
        @rollup = item.amount_calculated
      else
        @rollup += item.amount_calculated
      end
      #item.amount_calculated = Interval.find(item.interval_id).factor*item.amount
      row = [
        item.order_id,
        link_to(item.name, item),
        item.total_amount,
        item.amount_calculated,
        item.reserve,
        item.maturity,
        item.active,
        Category.find(item.category_id).name,
        Interval.find(item.interval_id).name,
        @rollup,
        find_account(item.account_id),
        item.external_account,
        item.key_words       
      ]
      puts data
      #Interval.find(item.interval_id).description,
      #Category.find(item.category_id).name,
      data.push(row)
    end
    return data
    #items.map do |item|
    #  [
    #    item.order_id,
    #    link_to(item.name, item),
    #    item.get_signed_amount,
     #   Category.find(item.category_id).name,
    #    item.maturity,
    #    item.active
    #  ]
    #end
  end
  
  def find_account(account_id)
    if Account.where(id: account_id).exists?
      @return = Account.find(account_id).description
    else
      @return = ''
    end
    return @return
  end
 
  def items
    @items ||= fetch_items
  end

  def fetch_items
    items = Item.order("#{sort_column} #{sort_direction}")
    items = items.page(page).per_page(per_page)
    if params[:sSearch].present?
      #search globally (in every column) -> 'OR'
      where_clause = ""
      get_columns.each_with_index do |column, index|  #key = "0", value = "order_id"
        if params["bSearchable_"+column[0]] == "true" and Item.column_names.include? column[1]
          if index == 0
            where_clause = column[1] + " like :search"
            puts where_clause
          else
            where_clause = where_clause + " OR " + column[1] + " like :search"
          end
        end
        puts where_clause
      end
      
      items = items.where(where_clause, search: "%#{params[:sSearch]}%")
    else
      #search in specific column(s) -> 'AND'
      params.each do |param|   
        if param.start_with?("sSearch_")
          column_no = param[-1]           #sSearch_0 -> 0
          if params["bSearchable_"+column_no] == "true" and Item.column_names.include? get_columns[column_no]
            if params[param].length > 0
              where_clause = get_columns[column_no].to_s + " like :search"
              items = items.where(where_clause, search: "%#{params[param]}%")
              #items = items.where("name like :search or category_id like :search", search: "%#{params[param]}%")
              #param_counter += param_counter + 1        
            end
          end
        end
      end
    end
    #return collected items
    items
  end


  def get_columns
    columns = Hash.new
    columns = {"0" => "order_id", "1" => "name", "2" => "total_amount", "3" => "amount_calculated", "4" => "reserve", "5" => "maturity", "6" => "active", "7" => "category_id", "8" => "interval_id", "9" => "rollup", "10" => "key_words"}
    #columns["order_id"] = 0
    #columns["name"] = 1
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
      return Item.count
     else
      return params[:iDisplayLength].to_i
    end
  end
  
  def sort_column
    columns = %w[order_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end