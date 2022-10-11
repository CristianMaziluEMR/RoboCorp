*** Settings ***
Documentation       Template robot main suite.

Library             RPA.FTP
Library             RPA.HTTP
Library             RPA.JSON
Library             RPA.Tables


*** Variables ***
${TRAFFIC_JSON_FILE_PATH}=      ${OUTPUT_DIR}${/}traffic.json


*** Tasks ***
Produce traffic data work items
    Download traffic data
    ${traffic_data}=    Load traffic data as table


*** Keywords ***
Download traffic data
    RPA.HTTP.Download
    ...    https://github.com/robocorp/inhuman-insurance-inc/raw/main/RS_198.json
    ...    ${TRAFFIC_JSON_FILE_PATH}
    ...    overwrite=True

Load traffic data as table
    ${json}=    Load JSON from file    ${TRAFFIC_JSON_FILE_PATH}
    ${table}=    Create Table    ${json}[value]
    Write table to CSV    ${table}    test.csv
    RETURN    ${table}
