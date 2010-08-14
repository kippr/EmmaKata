require 'nokogiri'
require 'open-uri'

def parse_package( package_row )
  package_name = package_row.xpath( './/a' ).first.content
  method_cover = package_row.xpath( './/td' )[2].content
  covered, uncovered = method_cover.scan( /\((\d+)\/(\d+)/ ).first.map( &:to_i )
  printf "%s : %s\n", package_name, method_cover
  printf "%s , %s\n%s\n", covered, uncovered, covered.class   
end

doc = Nokogiri::HTML(open('http://emma.sourceforge.net/coverage_sample_a/index.html'))

doc.xpath('//tr[@class="o"]').each do |row|
  parse_package( row )
end