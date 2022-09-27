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
Library             Collections
Library             RPA.Desktop


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
    ${orders}    Retreive list robot components from orders.csv
    FOR    ${order}    IN    @{orders}
        Fill order    ${order}

        Click Button    preview
        Screenshot    robot-preview-image    ${OUTPUT_DIR}${/}robot_preview.png
        Click Button    order
        Wait For Element    receipt
        ${receipt-html}    Get Element Attribute    receipt    outerHTML
        ${pdf-path}    ${OUTPUT_DIR}${/}receipt_for_robot_${order}[0].pdf
        Html To Pdf    ${receipt-html}    ${pdf-path}

        Open File    ${pdf-path}
        Add Files To Pdf    ${OUTPUT_DIR}${/}robot_preview.png    ${pdf-path}

        Click Button    order-another
    END

Retreive list robot components from orders.csv
    ${csv}    Get File    orders.csv
    @{read}    Create List    ${csv}

    @{orders}    Split To Lines    @{read}    1
    @{split-orders}    Create List
    FOR    ${order}    IN    @{orders}
        ${split-order}    Split String    ${order}    ,
        Append To List    ${split-orders}    ${split-order}
    END

    RETURN    ${split-orders}

Fill order
    [Arguments]    ${order}
    Select From List By Index    id:head    ${order}[1]
    Select Radio Button    body    ${order}[2]
    Input Text    class:form-control    ${order}[3]
    Input Text    id:address    ${order}[4]
