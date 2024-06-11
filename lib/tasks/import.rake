namespace :import do
  desc "Import movies from CSV"
  task movies: :environment do
    require 'smarter_csv'
    file_path = File.join(Rails.root, 'movies.csv')
    options = {}
    SmarterCSV.process(file_path, options) do |array|
      Movie.create!(array.first)
    end
  end
end
