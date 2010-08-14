require 'nokogiri'
require 'open-uri'

class EmmaScraper

  def parse_package( package_row )
    package_name = package_row.xpath( './/a' ).first.content
    method_cover = package_row.xpath( './/td' )[2].content
    covered, uncovered = method_cover.scan( /\((\d+)\/(\d+)/ ).first.map( &:to_i )
    #printf "%s : %s\n", package_name, method_cover
    #printf "%s , %s\n%s\n", covered, uncovered, covered.class
    return package_name, covered, uncovered   
  end
  
  def go
    doc = Nokogiri::HTML(open('http://emma.sourceforge.net/coverage_sample_a/index.html'))  
    doc.xpath('//tr[@class="o"]').map{|row| parse_package( row ) }
  end
end