*** Settings ***
Documentation       Template robot main suite.

Resource            shared.robot
Library             RPA.JSON


*** Tasks ***
Consume traffic data work items
    For Each Input Work Item    Process trafic data


*** Keywords ***
Process trafic data
    ${payload}=    Get Work Item Payload
    ${traffic_data}=    ${payload}${WORK_ITEM_NAME}
    ${valid}=    Validate traffic data    ${traffic_data}

Validate traffic data
    [Arguments]    ${traffic_data}
    ${country}=    Get value from JSON    ${traffic_data}    $.country
    ${valid}=    Evaluate    len("${country}") == 3
    RETURN    ${valid}
