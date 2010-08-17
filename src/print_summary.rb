require 'emma-scrape'

scraper = EmmaScraper.new(ARGV[0])
results = scraper.scrape
puts PrettyPrinter.new.as_string( results.roll_up )
