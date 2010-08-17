require 'emma-scrape'

describe EmmaScraper, "#scrape" do

  it "should find all packages and parse them correctly" do
    scraper = EmmaScraper.new
    results = scraper.scrape.scrape_data
    results.should have(26).items
    package, covered, total = results.last
    package.should == "org.apache.velocity.exception"
    covered.should == 44
  end

end

describe ScrapeResults, "#roll_up" do

  it "should roll up results to arbitrary level" do
    input =
      [ "org.apache.velocity.util.introspection", 10, 15 ],
      [ "org.apache.velocity.texen.util", 5, 10],
      [ "org.apache.velocity.util", 20, 30 ]
      
    results = ScrapeResults.new( input )
    covered, total = results.roll_up['org.apache.velocity.util']
    covered.should == 30
    total.should == 45
    
    covered, total = results.roll_up[ '* Total *' ]
    covered.should == 35
  end

end

describe PrettyPrinter, "#print_summary" do

  it "should put it nicely to screen dump-able format" do
    sample = {
      "my.package" => [30, 50]
    }
    result = PrettyPrinter.new.as_string( sample )
    result.should match( /my\.package[ ]+60.00%[ ]*\(30\/50\)/ )
  end

  it "should be sorted" do
    sample = {
      "PackC" => [10, 20],
      "PackA" => [10, 20],
      "PackB" => [10, 20]
    }
    result = PrettyPrinter.new.as_string( sample )
    result.should match( /PackA.*PackB.*PackC/m )
  end

end