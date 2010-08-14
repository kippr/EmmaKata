require 'emma-scrape'

describe EmmaScraper, "#check scraping" do
  it "should find all packages and parse them right" do
    scraper = EmmaScraper.new
    results = scraper.scrape
    results.should have(26).items
    package, uncovered, covered = results.last
    package.should == "org.apache.velocity.exception"
    covered.should == 44
  end
end

describe EmmaScraper, "#package rollup" do
  it "should roll up results to arbitrary level" do
  end
end