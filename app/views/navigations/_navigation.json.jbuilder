json.extract! navigation, :id, :display_text, :url, :html_class, :parent, :created_at, :updated_at
json.url navigation_url(navigation, format: :json)
