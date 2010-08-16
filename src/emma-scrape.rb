require 'nokogiri'
require 'open-uri'

class EmmaScraper

  def initialize( url = '../data/sample-emma.html')
    @url = url
  end

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
    doc = Nokogiri::HTML(open(@url))
    # :( doesn't seem to be a good way to identify our table 'cleanly', this is brittle
    # table 4 is our package table, and we want rows that have data cells, not header
    doc.xpath('//table[4]/tr/td/..').map{|row| parse_package_info( row ) }
  end
  
  def rolled_up
    results = Hash.new([0,0])
    scrape.each do |package, this_covered, this_total|
      sub_package = ""
      package.split('.').each do | piece |
        sub_package += piece
        running_covered, running_total, p = results[sub_package]
        running_covered += this_covered
        running_total += this_total
        results[sub_package] = running_covered, running_total
        sub_package += "."
      end
    end
    results
  end
  
  def filter ( packages )
    results = {}
    scrape.each do |package, this_covered, this_total|
      if packages.include?( package )
        results[package] = this_covered, this_total
      end
    end
    results
  end  
  
  def print_summary
    rolled_up.sort.each do | package, (cover, total) |
      percent = cover / total * 100
      printf "%-50s %5.2f%%  (%.0f/%.0f)\n", package, percent, cover, total
    end
  end
  
end


class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end