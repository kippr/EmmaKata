require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://emma.sourceforge.net/coverage_sample_a/index.html'))

doc.xpath('//tr[@class="o"]').each do |row|
  package = row.xpath('.//a').first.content
  method_cover = row.xpath('.//td')[2].content
  covered, uncovered = method_cover.scan(/\((\d+)\/(\d+)/).first.map(&:to_i)
  printf "%s : %s\n", package, method_cover
  printf "%s , %s\n%s\n", covered, uncovered, covered.class
end