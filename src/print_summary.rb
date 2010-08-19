require 'emma-scrape'
scraper = EmmaScraper.new(ARGV[0])
results = scraper.scrape
puts results.roll_up.to_pretty_string
puts " ----- "
project = [ "org.apache.velocity.context", "org.apache.velocity.texen" ]
puts results.filter( project ).to_pretty_string
