namespace :import do
  desc "Import reviews from CSV"
  task reviews: :environment do
    require 'smarter_csv'
    file_path = File.join(Rails.root, 'reviews.csv')
    options = {}
    SmarterCSV.process(file_path, options) do |rows|
      # Since SmarterCSV.process returns an array of hashes, handle the first element
      row = rows.first # Assuming each chunk contains data for one review
      movie = Movie.find_by(movie: row[:movie]) # Adjust if your model uses a different attribute
      if movie
        # Merge the movie object with the row hash
        Review.create!(row.merge(movie: movie))
      else
        puts "Movie named '#{row[:movie]}' not found"
      end
    end
  end
end
