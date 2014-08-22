require "capybara/cucumber"

Before('@selenium') do
  ::Capybara.current_driver = :light_sauce
end

Around('@selenium') do |scenario, block|
  JenkinsSauce.output_jenkins_log(scenario)
  block.call
  ::Capybara.current_session.driver.quit
end