*** Settings ***
Library    BuiltIn
Library    OperatingSystem
Library    String
Library    Process
Resource      variables.robot

*** Keywords ***
Open Website
    [Arguments]    ${URL}   ${BROWSER}
    Log    Open ${BROWSER} Browser (${URL})    console=True
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Sleep  4
    
Click Accept Cookies
    Click Element    xpath=//button[text()='Accept All']

Click Full Screen
    Click Element    xpath=//*[contains(@class, 'icon icon-ic_fullscreen_window')]

Click Zoom Out
    Click Element    xpath=//*[contains(@class, 'icon icon-ic_zoom_out_default')]   

Determine Range
    Wait Until Element Is Visible   class=page_of 
    ${range_txt}=  Get Text   xpath=//*[contains(@class, 'page_of')]
    # manipulate string from [of xxx] to [xxx] and return it
    ${range_number_str}=  Get Substring  ${range_txt}  3
    Log     ${range_number_str}
    RETURN    ${range_number_str}

Load All Pages    
    [Arguments]    ${range_number_str}
    ${page_input_element}=   Get WebElements    xpath=//*[@id="jump_page"]
    ${range_number}=  Convert To Integer    ${range_number_str}
    Log     ${range_number}
    # FOR Loop with range argument
    FOR    ${index}    IN RANGE    1    ${range_number}
        #Clear inputfield, put current index in inputfield and enter
        Click Element    xpath=//*[@id="jump_page"]
        Execute JavaScript    let inputField = document.getElementById('jump_page'); inputField.value = '';
        Input Text        xpath=//*[@id="jump_page"]    ${index}   True
        Execute JavaScript    let inputField = document.getElementById('jump_page'); let event = new KeyboardEvent('keydown', {key: 'Enter', keyCode: 13, code: 'Enter', which: 13, bubbles: true, cancelable: true}); inputField.dispatchEvent(event);
        Wait Until Element Is Visible   id=page${index}
        IF  ${SAVE_SCREENSHOTS} == True
            Get Image    ${index}    page${index}
        END
    END

Get Web Page Elements
    ${web_elements}=   Get WebElements    xpath=//*[contains(@class, 'newpage') and starts-with(@id, 'page')]
    Log  ${web_elements}[0]   
    Sleep  2s
    RETURN    ${web_elements}

Get Image 
    [Arguments]    ${index}    ${element_id}
    Scroll Element Into View        id=page${index}
    Capture Screenshot For Element    ${element_id}    ${index}

Loop Through Webelements For Images   #unused for now
    [Arguments]    ${web_elements}
    Log  ${web_elements}[0]
    FOR    ${index}    IN RANGE    0    ${web_elements.__len__()}
        ${element}=   Set Variable   ${web_elements}[${index}]
        ${element_id}=    Get Element Attribute    ${element}    id
        Scroll Element Into View        id=${element_id} 
        Capture Screenshot For Element    ${element_id}    ${index}
    END

Capture Screenshot For Element
    [Arguments]    ${element_id}    ${index}
    Log    Element ID: ${element_id}  # Logs the ID of the element
    IF    ${index} < 10
        ${index}=   Catenate  SEPARATOR=  00  ${index}
    ELSE IF    ${index} < 100
        ${index}=   Catenate  SEPARATOR=  0  ${index}
    END
    ${screenshot_name}=    Set Variable    ${index}_${element_id}_screenshot.png
    ${screenshot_path}=    Set Variable    ${SCREENSHOT_DIR}/${screenshot_name}
    Capture Element Screenshot    id:${element_id}     ${screenshot_path}   

Convert PNGs to PDF
    ${output}=    Run Process    python resources/PDF_script.py ${SCREENSHOTS_PATH} ${OUTPUT_PDF}    stdout=output.log    stderr=error.log
    Log    ${output}    

Create Html Content
    [Arguments]    ${web_elements}
    ${html}=    Set Variable    <!DOCTYPE html><html><head><title>Extracted Content</title><style> .newpage { page-break-before: always; }</style></head><body>
    FOR    ${element}    IN    @{web_elements}
        ${element_html}=    Call Method    ${element}    get_attribute    outerHTML
        ${html}=    Set Variable    ${html}<div style="width: 926px; height: 1449px;">${element_html}</div>
    END
    ${html}=    Set Variable    ${html}</body></html>
    Log   ${html}
    RETURN   ${html}

Save Html Content
    [Arguments]    ${content}    ${file_path}
    Create File    ${file_path}    ${content}

Teardown
    Close Browser 