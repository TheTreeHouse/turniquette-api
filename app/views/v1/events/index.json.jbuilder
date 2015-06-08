json.array!(@events) do |event|
  json.extract! event, :id, :name, :date, :periodicity, :owner
  json.success true
end
