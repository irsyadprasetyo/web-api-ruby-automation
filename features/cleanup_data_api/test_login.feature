@CleanupData
Feature: API Login

  Scenario: Login with api and get remember_token
  Given I login account spesific
  When I get response after login
  Then I should save the token
