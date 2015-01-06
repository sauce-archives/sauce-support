Feature:  Navigating somewhere
	
  @sauce
  Scenario: Going to rubygems.org
    Given I have opened http://www.rubygems.org
    Then I should see a box called 'query'