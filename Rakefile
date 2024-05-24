# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'dotenv/tasks'
require_relative "config/application"

Rails.application.load_tasks

# create a task that takes an url as param. It grabs the content of that url, and parses it.
# It is a csv file. Then we need to parse the csv file and create a new record in the database for each row.
# Columns are:
# - circuit_name
# - congregation_name
# - householder_name
# - householder_phone
# - neighborhood
# - street_name
# - number
# - complement
# - postal_code
# - latitude
# - longitude
desc 'Import CSV file from URL'
task :import_csv, [:url] => :environment do |task, args|
  AddressCsvImportService.new.import_csv(url: args[:url])
end
