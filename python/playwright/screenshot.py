import asyncio
from playwright.sync_api import sync_playwright, Playwright

def run(playwright: Playwright):
    """
    Launches a browser, navigates to the specified URL,
    and takes a screenshot of the leaderboard.

    def run(playwright: Playwright):
    This line defines the run function, but the playwright: Playwright part is a Python type hint.

    playwright: This is the name of the parameter that the run function accepts. It's just a variable name.

    : Playwright: This is the type hint. It tells anyone reading the code (and code editors like VS Code) that the playwright variable is expected to be an object of the Playwright class. The Playwright class is the main entry point provided by the library, which allows you to launch browsers (playwright.chromium, playwright.firefox, etc.).

    In short, it's a form of documentation inside the code. It doesn't force the variable to be that type, but it makes the code clearer and helps tools detect potential errors.
    """
    # URL of the page to capture
    url = "https://scale.com/leaderboard/humanitys_last_exam"
    
    # We'll use the Chromium browser, but you can also use 'firefox' or 'webkit'
    browser = playwright.chromium.launch()
    
    # Create a new page in the browser
    page = browser.new_page()
    
    try:
        print(f"Navigating to {url}...")
        # Go to the specified URL
        page.goto(url, wait_until="networkidle", timeout=60000)
        
        # Define the selector for the leaderboard table element
        # This helps ensure we capture the correct part of the page
        leaderboard_selector = "body > div > div.flex-1.font-inter > div > div > div:nth-child(2) > div > div.relative > div"
        
        print(f"Waiting for the leaderboard element ('{leaderboard_selector}') to be visible...")
        # Wait for the leaderboard element to be loaded and visible on the page
        page.wait_for_selector(leaderboard_selector, state="visible", timeout=30000)
        
        # Locate the specific leaderboard element
        leaderboard_element = page.locator(leaderboard_selector)
        
        # --- Option 1: Take a screenshot of just the leaderboard element ---
        screenshot_path_element = "leaderboard_element_screenshot.png"
        print(f"Taking a screenshot of the leaderboard element and saving to '{screenshot_path_element}'...")
        leaderboard_element.screenshot(path=screenshot_path_element)
        print("Element screenshot saved successfully!")

        # --- Option 2: Take a screenshot of the full page ---
        screenshot_path_full = "leaderboard_full_page_screenshot.png"
        print(f"\nTaking a full page screenshot and saving to '{screenshot_path_full}'...")
        page.screenshot(path=screenshot_path_full, full_page=True)
        print("Full page screenshot saved successfully!")

    except Exception as e:
        print(f"An error occurred: {e}")
        
    finally:
        # Close the browser
        print("Closing the browser.")
        browser.close()

def main():
    """
    Main function to run the Playwright script.\
    
    with sync_playwright() as playwright:
    This line uses a Python feature called a context manager. It's designed to properly manage resources, like starting and stopping a service.

    sync_playwright(): This function call starts up the Playwright service.

    with ... as playwright:: The with statement creates a temporary context. It ensures that no matter what happens inside the with block (even if there's an error), the necessary cleanup code is executed when the block is finished. In this case, it automatically and safely shuts down the Playwright service and any browsers it opened.

    as playwright: This takes the main Playwright object created by sync_playwright() and assigns it to a variable named playwright. This is the same variable that then gets passed into your run() function.

    Think of it like borrowing a tool. The with statement ensures you automatically return the tool (shut down Playwright) when you're done, so you don't accidentally leave it lying around (running browser processes in the background).
    """
    with sync_playwright() as playwright:
        run(playwright)

if __name__ == "__main__":
    # Before running this for the first time, you need to install the necessary browsers.
    # Run this command in your terminal:
    # playwright install
    main()
