require "spec_helper"

describe "The Front Page", :sauce => true do
  it "Should display the site title" do
    selenium.navigate.to 'http://localhost:3000/'
    expect(selenium.page_source).to include "barebones"
  end
end