require 'emma-scrape'

printer = PrettyPrinter.new

scraper = EmmaScraper.new(ARGV[0])
results = scraper.scrape
puts printer.as_string( results.roll_up )
puts " ----- "
project = [ "org.apache.velocity.context", "org.apache.velocity.texen" ]
puts printer.as_string( results.filter(  project ) )
