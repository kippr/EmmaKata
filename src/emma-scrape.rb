require 'nokogiri'
require 'open-uri'

class EmmaScraper

  def parse_package_info( row )
    
    # the td with link has our package name in it
    package = row.xpath( './td/a' ).first.content
    
    # and the 4th td is the block cover column
    block_cover = row.xpath( './td' )[3].content
    
    # regex is hard to read- this is capturing numeric X,Y from "(X/Y)"
    # result is list of capture groups, coerce first 'set' of captures into floats
    covered, total = block_cover.scan( /\((\d+)\/(\d+)/ ).first.map( &:to_f )
    
    return package, covered, total   
  end
  
  def scrape
    doc = Nokogiri::HTML(open('http://emma.sourceforge.net/coverage_sample_a/index.html'))  
    # :( doesn't seem to be a good way to identify our table 'cleanly', this is brittle
    # table 4 is our package table, and we want rows that have data cells, not header
    doc.xpath('//table[4]/tr/td/..').map{|row| parse_package_info( row ) }
  end
  
  def rolled_up
    results = Hash.new([0,0])
    scrape.each do |package, covered, total|
      sub_package = ""
      package.split('.').each do | piece |
        sub_package += piece
        old_covered, old_total = results[sub_package]
        results[sub_package] = old_covered + covered, old_total + total
        sub_package += "."
      end
    end
    results
  end
  
end


class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end