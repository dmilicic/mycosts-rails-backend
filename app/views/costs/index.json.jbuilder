json.array!(@costs) do |cost|
  json.extract! cost, :id, :category, :description, :date, :amount, :currency
  json.url cost_url(cost, format: :json)
end
