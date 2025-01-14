*** Settings ***
Library    SeleniumLibrary
Library    BuiltIn
Resource   ../resources/keywords.robot
Resource   ../resources/variables.robot

*** Test Cases ***
Get Images Scribd
    Log    Test begins    console=True
    Open Website   ${URL}   ${BROWSER}
    Click Accept Cookies
    Click Full Screen
    Click Zoom Out
    Click Zoom Out
    Click Zoom Out
    Click Zoom Out
    ${range_number}=    Determine Range
    Load All Pages    ${range_number}
    IF  ${SAVE_SCREENSHOTS} == True and ${SCREENSHOT_WHILE_LOADING} == False
        ${web_elements}=    Get Web Page Elements
        Loop Through Webelements For Images    ${web_elements}
    END
    #Convert PNGs to PDF --> start script manually
    IF  ${SAVE_HTML}
        ${web_elements}=    Get Web Page Elements
        ${html_content}=        Create Html Content  ${web_elements}
        Save Html Content     ${html_content}   ${HTML_FILE}
    END
# TO DO: convert HTML file to PDF and save? Styling may be an issue

