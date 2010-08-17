require 'nokogiri'
require 'open-uri'

class EmmaScraper

  def initialize( url = '../data/sample-emma.html')
    @url = url
  end

  def scrape
    doc = Nokogiri::HTML(open(@url))
    # :( doesn't seem to be a good way to identify our table 'cleanly', this is brittle
    # table 4 is our package table, and we want rows that have data cells, not header
    scrape_hash = doc.xpath('//table[4]/tr/td/..').map{|row| parse_package_info( row ) }
    ScrapeResults.new( scrape_hash )
  end

  private
    def parse_package_info( row )

      # the td with link has our package name in it
      package = row.xpath( './td/a' ).first.content

      # and the 4th td is the block cover column
      block_cover = row.xpath( './td' )[3].content

      # regex is hard to read- this is capturing numeric X,Y from "(X/Y)"
      # result is list of capture groups, coerce first 'set' of captures into floats
      covered, total = block_cover.scan( /\((\d+)\/(\d+)/ ).first.map( &:to_f )

      [package, covered, total]
    end
    
end

class ScrapeResults
  
  attr_reader :scrape_data
  
  def initialize( scrape )
    @scrape_data = scrape
  end
  
  def roll_up
    results = Hash.new([0,0])
    total_cover = 0
    total_total = 0
    @scrape_data.each do |package, this_covered, this_total|
      total_cover += this_covered
      total_total += this_total
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
    results[ '* Total *'] = total_cover, total_total
    results
  end
  
  # todo: dupe on total count
  def filter ( packages )
    results = {}
    total_cover = 0
    total_total = 0
    roll_up.each do |package, ( this_covered, this_total ) |
      if (packages.any?{ | p | package.starts_with?( p ) } )
        results[package] = this_covered, this_total
        if packages.include?( package )
          total_cover += this_covered
          total_total += this_total
        end
      end
    end
    results[ '* Total *'] = total_cover, total_total
    results
  end  

end

class PrettyPrinter

  def as_string( scraper_output )
    output = scraper_output.sort.map do | package, (cover, total) |
      percent = cover.to_f / total.to_f * 100.0
      sprintf "%-50s %5.2f%%  (%.0f/%.0f)", package, percent, cover, total
    end
    output.join("\n")
  end

end

class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end