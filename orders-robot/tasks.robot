*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${true}
Library             RPA.Robocorp.Vault
Library             RPA.HTTP
Library             RPA.Excel.Files
Library             RPA.PDF
Library             String
Library             OperatingSystem
Library             String
Library             Collections


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
    ${orders}    Retreive list robot component dictionaries from orders.csv
    FOR    ${order}    IN    @{orders}
        Fill and submit one order    ${order}
    END

Retreive list robot component dictionaries from orders.csv
    ${csv}    Get File    orders.csv
    @{read}    Create List    ${csv}

    @{orders}    Split To Lines    @{read}    1
    @{split-orders}    Create List
    FOR    ${order}    IN    @{orders}
        ${split-order}    Split String    ${order}    ,
        Append To List    ${split-orders}    ${split-order}
    END

    RETURN    ${split-orders}

Fill and submit one order
    [Arguments]    ${order}
    Log To Console    Head of robot is number ${order}[0]
    Log To Console    Address of robot is number ${order}[4]
