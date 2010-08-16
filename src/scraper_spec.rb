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
  covered, total = scraper.rolled_up['org.apache.velocity.util']
  covered.should == 1659
  total.should == 2705
  end
end


describe EmmaScraper, "#project filter" do
  it "should summarize coverage for selected packages" do
    scraper = EmmaScraper.new
    project_packages = "org.apache.velocity.texen", "org.apache.velocity.texen.util", "org.apache.velocity.io"
    results = scraper.filter(project_packages)
    covered, total = results["org.apache.velocity.texen.util"]
    covered.should == 98
    covered, total = results["summary"]
    total.should == 954
    # todo: should we do the regular roll-up here?
  end
end