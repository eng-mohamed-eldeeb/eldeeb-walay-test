json.extract! movie, :id, :movie, :description, :year, :director, :actor, :location, :country, :created_at, :updated_at
json.url movie_url(movie, format: :json)
