*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${false}
Library             RPA.Robocorp.Vault
Library             RPA.HTTP
Library             RPA.Excel.Files
Library             RPA.PDF
Library             String
Library             OperatingSystem
Library             String


*** Tasks ***
Get the orders and submit them into the order form
    Open the RSBI website
    Read vault credentials and log in
    Download the Excel file
    Navigate to Orders page
    Fill the form using orders.csv data


*** Keywords ***
Open the RSBI website
    Open Available Browser    https://robotsparebinindustries.com/

Read vault credentials and log in
    ${secret}    Get Secret    credentials
    Input Text    username    ${secret}[username]
    Input Password    password    ${secret}[password]
    Submit Form
    Wait Until Page Contains Element    id:sales-form

Download the Excel file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=true

Navigate to Orders page
    Go To    https://robotsparebinindustries.com/#/robot-order
    Bypass annoying pop-up

Bypass annoying pop-up
    Wait Until Page Contains Element    class:btn-warning
    Click Button    class:btn-warning

Fill the form using orders.csv data
    @{orders}    Retreive list of lines from orders.csv
    FOR    ${order}    IN    @{orders}
        &{order-dict}    Convert order line to dictionary    ${order}
        Log To Console    ${order-dict}[address]
    END

Retreive list of lines from orders.csv
    ${csv}    Get File    orders.csv
    @{read}    Create List    ${csv}
    @{orders}    Split To Lines    @{read}    1
    RETURN    @{orders}

Convert order line to dictionary
    [Arguments]    ${order}
    ${split-order}    Split String    ${order}    ,
    Log To Console    ${split-order}[4]
    &{order-dict}    Create Dictionary
    ...    order-number=${split-order}[0]
    ...    head=${split-order}[1]
    ...    body=${split-order}[2]
    ...    legs=${split-order}[3]
    ...    address=${split-order}[4]
    RETURN    &{order-dict}

Fill and submit one order
    [Arguments]    ${order}
    Log    Head of robot is number ${order}[Head] + 1
    Select From List By Index    id:head    ${order}[Head] + 1
