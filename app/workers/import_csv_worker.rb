require 'smarter_csv'

class ImportCsvWorker
  include Sidekiq::Worker

  def perform(csv_file_path, type)
    options = {}
    case type
    when 'movies'
      SmarterCSV.process(csv_file_path, options) do |array|
        import_movie(array.first) # Process each chunk, assuming one movie per chunk
      end
    when 'reviews'
      SmarterCSV.process(csv_file_path, options) do |rows|
        rows.each { |row| import_review(row) } # Process each row in the chunk
      end
    else
      raise "Unknown CSV type: #{type}"
    end
  end

  private

  def import_movie(movie_attrs)
    movie = Movie.find_or_initialize_by(movie: movie_attrs[:movie])
    movie.description ||= movie_attrs[:description]
    movie.year ||= movie_attrs[:year]
    movie.director ||= movie_attrs[:director]
    movie.filming_location ||= movie_attrs[:filming_location]
    movie.country ||= movie_attrs[:country]
    movie.actors = (movie.actors || []) | [movie_attrs[:actors]].flatten # Ensure unique actors and handle as array
    movie.save!
  end

  def import_review(row)
    movie = Movie.find_by(movie: row[:movie])
    if movie
      Review.create!(row.merge(movie_id: movie.id).except(:movie)) # Exclude :movie from row hash
    else
      puts "Movie named '#{row[:movie]}' not found"
    end
  end
end
