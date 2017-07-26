json.extract! account, :id, :account_number, :description, :iban, :bic, :created_at, :updated_at
json.url account_url(account, format: :json)
