require "spec_helper"

describe "The Front Page", :type => :feature, :sauce => true do
  it "Should display the site title using Capybara" do
    visit '/'
    expect(page).to have_content "barebones"
  end
end