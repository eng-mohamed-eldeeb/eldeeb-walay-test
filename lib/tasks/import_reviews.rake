namespace :import do
  desc "Import reviews from CSV"
  task reviews: :environment do
    require 'smarter_csv'
    file_path = File.join(Rails.root, 'reviews.csv')
    options = {}
    SmarterCSV.process(file_path, options) do |rows|
      row = rows.first
      movie = Movie.find_by(movie: row[:movie])
      if movie
        Review.create!(row.merge(movie: movie))
      else
        puts "Movie named '#{row[:movie]}' not found"
      end
    end
  end
end
