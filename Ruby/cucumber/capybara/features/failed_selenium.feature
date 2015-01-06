Feature:  Navigating somewhere else
	
  @sauce
  Scenario: Going to fhdgest.com
    Given I have opened http://fhdgest.com
    Then I should not see a box called 'query'