require 'emma-scrape'

scraper = EmmaScraper.new(  "../data/sample-emma.html" )
results = scraper.scrape

puts "Parsed #{scraper.url}"

puts " -------------------------------- "
puts " -------------------------------- "
puts "All results with roll up"
puts " -------------------------------- "
puts results.roll_up.to_pretty_string

puts " -------------------------------- "
puts " -------------------------------- "
puts "Project packages, no roll up"
puts " -------------------------------- "
project = [ "org.apache.velocity.context", "org.apache.velocity.texen" ]
puts results.filter( project ).to_pretty_string

puts " -------------------------------- "
puts " -------------------------------- "
puts "Project package, with roll up"
puts " -------------------------------- "
puts results.filter( project ).roll_up.to_pretty_string
