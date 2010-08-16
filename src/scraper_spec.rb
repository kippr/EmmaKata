require 'emma-scrape'

describe EmmaScraper, "#scrape" do

  it "should find all packages and parse them correctly" do
    scraper = EmmaScraper.new
    results = scraper.scrape
    results.should have(26).items
    package, covered, total = results.last
    package.should == "org.apache.velocity.exception"
    covered.should == 44
  end

end

describe EmmaScraper, "#roll_up" do

  it "should roll up results to arbitrary level" do
    scraper = EmmaScraper.new
    covered, total = scraper.roll_up['org.apache.velocity.util']
    covered.should == 1659
    total.should == 2705
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