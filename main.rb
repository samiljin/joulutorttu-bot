require 'csv'
require 'twitter'
require 'aws-sdk-s3'

s3      = Aws::S3::Client.new
$object = s3.get_object(bucket: 'joulutorttu-bot',
                        key:    'assets/data.csv')

def run(event:, context:)
  file = Tempfile.new(['data', '.csv'])
  file.write($object.body.read)
  file.close

  csv_rows = CSV.read(file.path, col_sep: ';')
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
end
