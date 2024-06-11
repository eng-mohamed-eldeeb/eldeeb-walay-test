namespace :import do
  desc "Import movies from CSV"
  task movies: :environment do
    require 'smarter_csv'
    file_path = File.join(Rails.root, 'movies.csv')
    options = {}
    SmarterCSV.process(file_path, options) do |array|
      movie_attrs = array.first
      movie = Movie.find_or_initialize_by(movie: movie_attrs[:movie])
      movie.description ||= movie_attrs[:description]
      movie.year ||= movie_attrs[:year]
      movie.director ||= movie_attrs[:director]
      movie.filming_location ||= movie_attrs[:filming_location]
      movie.country ||= movie_attrs[:country]
      movie.actors = (movie.actors || []) | [movie_attrs[:actor]]
      movie.save!
    end
  end
end
