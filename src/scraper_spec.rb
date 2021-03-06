require 'emma-scrape'

describe EmmaScraper, "#scrape" do

  before do
    scraper = EmmaScraper.new
    @results = scraper.scrape.data
  end

  it "should find all packages" do
    @results.should have(26).items
  end
  
  it "should parse each package for coverage" do
    covered, total = @results["org.apache.velocity.context"]
    covered.should == 368
    total.should == 484
  end

end

describe ScrapeResults, "#roll_up" do
  
  before do
    input = {
      "org.apache.velocity.util.introspection" => [10, 15],
      "org.apache.velocity.texen.util" => [5, 10],
      "org.apache.velocity.util" => [20, 30]
      } 
    @results = ScrapeResults.new( input )
  end
  
  
  it "should summarize results to arbitrary level" do
    covered, total = @results.roll_up.data['org.apache.velocity.util']
    covered.should == 30
    total.should == 45
  end
  
  it "should add a grand total row" do
    covered, total = @results.roll_up.data[ '* Total *' ]
    covered.should == 35
  end

end

describe ScrapeResults, "#filter" do

  before do
    input = {
      "org.apache.velocity.texen" => [ 10, 15 ],
      "org.apache.velocity.texen.util" => [ 3, 3 ],
      "org.apache.velocity.io" => [ 0, 100 ],
      "org.apache.velocity.util" => [ 918, 1000 ]
      }
        
    project_packages = "org.apache.velocity.texen", "org.apache.velocity.io"    
    @filtered_results = ScrapeResults.new( input ).filter( project_packages )    
  end
    
  it "should return coverage for selected packages only" do
    covered, total = @filtered_results.data["org.apache.velocity.texen.util"]
    covered.should == 3
  end
  
  it "should support roll-up for the filtered packages" do
    covered, total = @filtered_results.roll_up.data[ "* Total *" ]
    covered.should == 13
    total.should == 118
  end

end

describe ScrapeResults, "#to_pretty_string" do

  it "should turn results into pleasing screen dump-able format" do
    sample = {
      "my.package" => [30, 50]
    }
    result = ScrapeResults.new( sample ).to_pretty_string
    result.should match( /my\.package[ ]+60.00%[ ]*\(30\/50\)/ )
  end

  it "should sort output" do
    sample = {
      "PackC" => [10, 20],
      "PackA" => [10, 20],
      "PackB" => [10, 20]
    }
    result = ScrapeResults.new( sample ).to_pretty_string 
    result.should match( /PackA.*PackB.*PackC/m )
  end

end