require 'emma-scrape'

describe EmmaScraper, "#check scraping" do
  it "should find all packages and parse them right" do
    scraper = EmmaScraper.new
    results = scraper.scrape
    results.should have(26).items
    package, covered, total = results.last
    package.should == "org.apache.velocity.exception"
    covered.should == 44
  end
end

describe EmmaScraper, "#package rollup" do
  it "should roll up results to arbitrary level" do
  scraper = EmmaScraper.new
  results = scraper.rolled_up
  #p results
  covered, total = results['org.apache.velocity.util']
  covered.should == 1659
  total.should == 2705
  end
end