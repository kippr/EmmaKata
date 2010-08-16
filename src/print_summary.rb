require 'emma-scrape'

scraper = EmmaScraper.new(ARGV[0])
puts PrettyPrinter.new.as_string( scraper.roll_up )
