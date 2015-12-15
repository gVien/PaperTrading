# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Seed the stock data from command line (rake task versus using seed.rb)
# https://dwradcliffe.com/2011/12/29/import-csv.html
# `be rake -T` to see all commands then `be rake import`
desc "Import stock symbols and names from csv file"
task :import => [:environment] do

  file = "db/companylist.csv" # this contains over 5k of stocks (production level will have more than that ~25k)

  CSV.foreach(file, :headers => true) do |row|
    Stock.create({
      symbol: row[0],
      company_name: row[1]
    })
  end
end