@SampleFeature
Feature: Login

  Scenario: Verify owner can login successfully
    Given Owner login backoffice with user data "pos1" and outlet number 4
    Then Owner should see "Dashboard" in dashboard page
