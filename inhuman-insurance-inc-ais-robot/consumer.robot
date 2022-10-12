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
    ${traffic_data}=    Set Variable    ${payload}[${WORK_ITEM_NAME}]
    ${valid}=    Validate traffic data    ${traffic_data}
    IF    ${VALID}    Post traffic data to sales System    ${traffic_data}

Validate traffic data
    [Arguments]    ${traffic_data}
    ${country}=    Get value from JSON    ${traffic_data}    $.country
    ${valid}=    Evaluate    len("${country}") == 3
    RETURN    ${valid}

Post traffic data to sales System
    [Arguments]    ${traffic_data}
    ${status}    ${return}=    Run Keyword And Ignore Error
    ...    POST
    ...    https://robocorp.com/inhuman-insurance-inc/sales-system-api
    ...    json=${traffic_data}
    Handle traffic API resonse    ${status}    ${return}    ${traffic_data}

Handle traffic API resonse
    [Arguments]    ${status}    ${return}    ${traffic_data}
    IF    "${status}" == "PASS"
        Handle traffic API OK response
    ELSE
        Handle traffic API error response    ${return}    ${traffic_data}
    END

Handle traffic API OK response
    Release Input Work Item    DONE

Handle traffic API error response
    [Arguments]    ${return}    ${traffic_data}
    Log
    ...    Traffic data posting failed: ${traffic_data} ${return}
    ...    ERROR
    Release Input Work Item
    ...    state=failed
    ...    exception_type=APPLICATION
    ...    code=TRAFFIC_DATA_POST_FAILED
    ...    message=${return}
