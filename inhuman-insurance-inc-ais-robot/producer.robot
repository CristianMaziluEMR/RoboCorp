*** Settings ***
Documentation       Template robot main suite.

Library             RPA.FTP
Library             RPA.HTTP


*** Tasks ***
Produce traffic data work items
    Download traffic data


*** Keywords ***
Download traffic data
    RPA.HTTP.Download
    ...    https://github.com/robocorp/inhuman-insurance-inc/raw/main/RS_198.json
    ...    ${OUTPUT_DIR}${/}traffic.json
    ...    overwrite=True
