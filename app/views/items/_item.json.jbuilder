json.extract! item, :id, :order_id, :name, :total_amount, :amount_calculated, :reserve, :maturity, :active, :category_id, :interval_id, :created_at, :updated_at
json.url item_url(item, format: :json)
