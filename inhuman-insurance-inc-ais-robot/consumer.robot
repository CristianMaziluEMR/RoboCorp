*** Settings ***
Documentation       Template robot main suite.

Resource            shared.robot


*** Tasks ***
Consume traffic data work items
    For Each Input Work Item    Process trafic data


*** Keywords ***
Process trafic data
    ${payload}=    Get Work Item Payload
    ${traffic_data}=    ${payload}${WORK_ITEM_NAME}
