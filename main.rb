# frozen_string_literal: true

require 'csv'
require 'twitter'

csv_rows = CSV.read('data.csv', col_sep: ';')
csv_rows.shift # Remove the first as its just the headers.

ingredients = csv_rows.map do |row|
  row[1].split(',').first
end

ingredients.uniq!

ingredient = ingredients.sample(1).first

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TORTTU_TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TORTTU_TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TORTTU_TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TORTTU_TWITTER_ACCESS_TOKEN_SECRET']
end

recipe = "#{ingredient} -joulutorttu"
client.update(recipe)
