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
    #"0" => "id", "1" => "period", "2" => "item_id", "3" => "planned_value", "4" => "actual_value"
    monthly_statistics.all.order(:period).each_with_index do |monthly_statistic, index|
      row = [
        link_to(monthly_statistic.id, monthly_statistic),
        monthly_statistic.period,
        Item.find(monthly_statistic.item_id).name,
        monthly_statistic.planned_value,
        monthly_statistic.actual_value
      ]
      data.push(row)
    end
    return data
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
            if params[param].length > 0
              where_clause = get_columns[column_no].to_s + " like :search"
              monthly_statistics = monthly_statistics.where(where_clause, search: "%#{params[param]}%")   
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
    columns = {"0" => "id", "1" => "period", "2" => "item_id", "3" => "planned_value", "4" => "actual_value" }
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