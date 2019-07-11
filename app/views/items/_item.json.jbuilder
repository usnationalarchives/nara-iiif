json.extract! item, :id, :title, :description, :body, :created_at, :updated_at
json.url item_url(item, format: :json)
