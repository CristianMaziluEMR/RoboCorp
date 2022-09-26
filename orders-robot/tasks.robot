*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${false}
Library             RPA.Robocorp.Vault
Library             RPA.HTTP
Library             RPA.Excel.Files
Library             RPA.PDF


*** Tasks ***
Get the orders and submit them into the order form
    Open the RSBI website
    Read vault credentials and log in
    Download the Excel file


*** Keywords ***
Open the RSBI website
    Open Available Browser    https://robotsparebinindustries.com/

Read vault credentials and log in
    ${secret}=    Get Secret    credentials

Download the Excel file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=true
