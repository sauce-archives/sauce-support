Given /I have opened (http:\/\/[a-zA-Z\.]+)/ do |url|
  visit url
end

Then /I should see a box called '([a-zA-Z]+)'/ do |name|
  element = page.find_field name
  fail if element.nil? 
end

Then /I should not see a box called '([a-zA-Z]+)'/ do |name|
  begin
    element = page.find_field name
  rescue
  end
  fail if element
end