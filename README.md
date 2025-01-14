# Book_Extractor_Test
Robot test to extract books from Scribd

1. Generate and save screenshots/HTML of pages
Robot command from tests dir: 
    ...Book_Extractor_Test\tests>robot --outputdir results test_cases/extract_test.robot

2. Put screenshots in a combined PDF with PDF_script.py  (TO DO: integrate in test)
Python command from resources dir:  
    ...Book_Extractor_Test\tests\resources>python PDF_script.py ../results/screenshots ../results/PDF/extracted-book.pdf
