json.array!(@routines) do |routine|
  json.extract! routine, :id, :title, :purpose, :resources, :weeks, :days, :hours, :minutes, :user_id
  json.url routine_url(routine, format: :json)
end
