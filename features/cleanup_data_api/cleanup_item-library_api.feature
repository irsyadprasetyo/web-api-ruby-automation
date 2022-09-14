@CleanupData
Feature: Cleanup data using API

    Scenario Outline: Cleanup Item Library
    Given SEIT login backoffice <data> <password> with api
    And SEIT prepare for cleanup data
    And SEIT do cleanup data for
    | data         |
    | ingredient   |
    | item         |
    | modifiers    |
    #| categories   |
    #| discounts    |
    #| taxes        |
    #| gratuity     |
    #| salestype    |

    Examples:
    | data                         | password            |
    | "moka-seit-a@mailinator.com" | "moka-seit-a123456" |
    | "moka-seit-b@mailinator.com" | "moka-seit-b123456" |
    #| "moka-seit-c@mailinator.com" | "moka-seit-c123456" |
