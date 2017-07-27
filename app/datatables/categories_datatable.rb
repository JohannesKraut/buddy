class CategoriesDatatable
  delegate :params, :h, :link_to, to: :@view
  
  #define scope for db-lookup
  #scope :featured, -> { where(:featured => true) }
  #scope :by_degree, -> degree { where(:degree => degree) }
  #name, credit
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Category.count,
      iTotalDisplayRecords: categories.total_entries,
      aaData: data
    }
  end

private

  def data
    data = Array.new
    categories.all.order(:name).each_with_index do |category, index|
      row = [
        category.name,
        category.credit
      ]
      data.push(row)
    end
    puts data
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
 
  def categories
    @categories ||= fetch_categories
  end

  def fetch_categories
    categories = Category.order("#{sort_column} #{sort_direction}")
    categories = categories.page(page).per_page(per_page)
    if params[:sSearch].present?
      #search globally (in every column) -> 'OR'
      where_clause = ""
      get_columns.each_with_index do |column, index|  #key = "0", value = "order_id"
        if params["bSearchable_"+column[0]] == "true" and Category.column_names.include? column[1]
          if index == 0
            where_clause = column[1] + " like :search"
            puts where_clause
          else
            where_clause = where_clause + " OR " + column[1] + " like :search"
          end
        end
        puts where_clause
      end
      
      categories = categories.where(where_clause, search: "%#{params[:sSearch]}%")
    else
      #search in specific column(s) -> 'AND'
      params.each do |param|   
        if param.start_with?("sSearch_")
          column_no = param[-1]           #sSearch_0 -> 0
          if params["bSearchable_"+column_no] == "true" and Category.column_names.include? get_columns[column_no]
            if params[param].length > 0
              where_clause = get_columns[column_no].to_s + " like :search"
              categories = categories.where(where_clause, search: "%#{params[param]}%")      
            end
          end
        end
      end
    end
    #return collected items
    categories
  end
  
  def get_columns
    columns = Hash.new
    columns = {"0" => "name", "1" => "credit"}
    return columns
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    #params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    if params[:iDisplayLength].to_i < 0
      return Category.count
     else
      return params[:iDisplayLength].to_i
    end
  end

  def sort_column
    columns = %w[id name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end