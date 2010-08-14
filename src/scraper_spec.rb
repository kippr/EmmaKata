require 'emma-scrape'

describe EmmaScraper, "#check final piece" do
  it "returns package name" do
    scraper = EmmaScraper.new
    results = scraper.go
    results.should have(26).items
    package, uncovered, covered = results.last
    package.should == "org.apache.velocity.exception"
    covered.should == 44
  end
end