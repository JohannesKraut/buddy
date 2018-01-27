class MonthlyStatisticsDatatable
  delegate :params, :h, :link_to, to: :@view
  
  #define scope for db-lookup
  #scope :featured, -> { where(:featured => true) }
  #scope :by_degree, -> degree { where(:degree => degree) }
  
  #:period, :planned_value, :actual_value, :item_id
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: MonthlyStatistic.count,
      iTotalDisplayRecords: monthly_statistics.total_entries,
      aaData: data
    }
  end

private

  def data
    data = Array.new
    if params[:sSearch_1].present?
      date_range = params[:sSearch_1].split(";")
      statistics = monthly_statistics.where('period BETWEEN ? AND ?', date_range[0], date_range[1])
    else
      statistics = monthly_statistics.all
    end
   
    #"0" => "id", "1" => "period", "2" => "item_id", "3" => "planned_value", "4" => "actual_value"
    statistics.order(:period).each_with_index do |monthly_statistic, index|
    #monthly_statistics.all.order(:period).each_with_index do |monthly_statistic, index|
      #@transaction = find_transaction(monthly_statistic.hibiscus_sync_id)
      #@transaction["text"] 
        #Account.find(monthly_statistic.account_id).description,
        #find_item(monthly_statistic.item_id),
              
      row = [
        link_to(monthly_statistic.id, monthly_statistic),
        monthly_statistic.period,
        monthly_statistic.account_id,
        monthly_statistic.item_id,
        monthly_statistic.planned_value,
        monthly_statistic.actual_value,
        monthly_statistic.hibiscus_sync_id,
        monthly_statistic.match_confidence,
        monthly_statistic.match_type,
        monthly_statistic.match_value,
        monthly_statistic.text
      ]
      data.push(row)
    end
    return data
  end
  
  def find_transaction(hibiscus_sync_id)
    @return = Hash.new
    @return["text"] = ''
    @return["account"] = ''
    @return["type"] = ''

    if HibiscusTransaction.where(id: hibiscus_sync_id).exists?
      @transaction = HibiscusTransaction.find(hibiscus_sync_id)
      if @transaction.zweck.present?
        @return["text"] += @transaction.zweck
      end
      if @transaction.zweck2.present?
        @return["text"] += @transaction.zweck2
      end
      if @transaction.zweck3.present?
        @return["text"] += @transaction.zweck3
      end
      
      if @transaction.art.present?
        @return["account"] = @transaction.konto_id
      end
      
      if @transaction.art.present?
        @return["type"] = @transaction.art
      end
    end
    return @return 
  end
  
    def find_item(item_id)
    if Item.where(id: item_id).exists?
      @return = Item.find(item_id).name
    else
      @return = ''
    end
    return @return
  end
 
  def monthly_statistics
    @monthly_statistics ||= fetch_monthly_statistics
  end

  def fetch_monthly_statistics
    monthly_statistics = MonthlyStatistic.order("#{sort_column} #{sort_direction}")
    monthly_statistics = monthly_statistics.page(page).per_page(per_page)
    if params[:sSearch].present?
      #search globally (in every column) -> 'OR'
      where_clause = ""
      get_columns.each_with_index do |column, index|  #key = "0", value = "order_id"
        if params["bSearchable_"+column[0]] == "true" and MonthlyStatistic.column_names.include? column[1]
          if index == 0
            where_clause = column[1] + " like :search"
            puts where_clause
          else
            where_clause = where_clause + " OR " + column[1] + " like :search"
          end
        end
        puts where_clause
      end
      
      monthly_statistics = monthly_statistics.where(where_clause, search: "%#{params[:sSearch]}%")
    else
      #search in specific column(s) -> 'AND'
      params.each do |param|   
        if param.start_with?("sSearch_")
          column_no = param[-1]           #sSearch_0 -> 0
          if params["bSearchable_"+column_no] == "true" and MonthlyStatistic.column_names.include? get_columns[column_no]
            puts "Current param " + param
            if params[param].length > 0 and param != 'sSearch_1'
              where_clause = get_columns[column_no].to_s + " like :search"
              monthly_statistics = monthly_statistics.where(where_clause, search: "#{params[param]}")   
            end
          end
        end
      end
    end
    #return collected items
    monthly_statistics
  end
  
  def get_columns
    columns = Hash.new
    #:period, :planned_value, :actual_value, :item_id
    columns = {"0" => "id", "1" => "period", "2" => "account_id", "3" => "item_id", "4" => "planned_value", "5" => "actual_value", "6" => "hibiscus_sync_id", "7" => "match_confidence", "8" => "match_type", "9" => "match_value"}
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
      return MonthlyStatistic.count
     else
      return params[:iDisplayLength].to_i
    end
  end

  def sort_column
    columns = %w[period item_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end