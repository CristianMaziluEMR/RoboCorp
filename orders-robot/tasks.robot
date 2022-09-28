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
Library             RPA.Windows


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
    Wait Until Page Contains Element    class:btn-warning
    ${pop-up-buttons}    Create List    btn-warning    btn-dark    btn-danger    btn-success
    FOR    ${pop-up-button}    IN    @{pop-up-buttons}
        Log    Pressed ${pop-up-button}
        ${button-presssed-successfully}    Set Variable    ${False}
        TRY
            Click Button    class:${pop-up-button}
        EXCEPT    ElementNotInteractableException: Message: element not interactable
            CONTINUE
        FINALLY
            ${button-presssed-successfully}    Set Variable    ${True}
        END

        IF    "${button-presssed-successfully}" == "${True}"    BREAK
        Click Button    class:btn-warning
    END

Fill the form using orders.csv data
    ${orders}    Retreive list robot components from orders.csv
    FOR    ${order}    IN    @{orders}
        Bypass annoying pop-up
        Fill order    ${order}

        Click Button    preview
        ${image-path}    Set Variable    ${OUTPUT_DIR}${/}robot_preview.png
        RPA.Browser.Selenium.Screenshot    robot-preview-image    ${image-path}
        Click Button    order
        ${receipt-html}    Get Element Attribute    receipt    outerHTML
        ${pdf-path}    Set Variable    ${OUTPUT_DIR}${/}receipt_for_robot_${order}[0].pdf
        Html To Pdf    ${receipt-html}    ${pdf-path}

        ${list-of-images-for-pdf}    Create List    ${image-path}
        Add Files To Pdf    ${list-of-images-for-pdf}    ${pdf-path}
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
