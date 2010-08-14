require 'emma-scrape'

describe EmmaScraper, "#check final piece" do
  it "returns package name" do
    scraper = EmmaScraper.new
    package, uncovered, covered = scraper.go.last
    package.should == "org.apache.velocity.exception"
  end
end