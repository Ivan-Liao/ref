# Benefits 
1. Full browser execution vs Raw HTML only
2. Moderate speed with resource blocking
3. Supports logins, clicks, and infinite scrolls

# Code
```
import asyncio
import json
from playwright.async_api import async_playwright
import pandas as pd

# Target site configuration
BASE_URL = "https://www.scrapingcourse.com/ecommerce/"

async def handle_route(route):
    """Intercept and block heavy resources to dramatically speed up scraping."""
    if route.request.resource_type in ["image", "font", "stylesheet"]:
        await route.abort()
    else:
        await route.continue_()

async def scrape_products():
    async with async_playwright() as p:
        # Launch Chromium with anti-detection settings
        browser = await p.chromium.launch(
            headless=True,
            args=["--disable-blink-features=AutomationControlled"]
        )
        
        # Create an isolated browser context with a realistic user-agent
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        
        page = await context.new_page()
        
        # Optimize performance by blocking images and CSS
        await page.route("**/*", handle_route)
        
        # Navigate and return early once the DOM is ready (ignore full page load)
        await page.goto(BASE_URL, wait_until="domcontentloaded")
        
        all_products = []
        page_number = 1
        
        while True:
            print(f"Scraping page {page_number}...")
            
            # Use reliable Locators that automatically wait for elements to load
            product_elements = page.locator(".product")
            count = await product_elements.count()
            
            if count == 0:
                break
                
            for i in range(count):
                product = product_elements.nth(i)
                
                # Extract text context accurately
                title = await product.locator(".ecommerce-product-title").text_content()
                price = await product.locator(".price").text_content()
                
                all_products.append({
                    "title": title.strip() if title else "N/A",
                    "price": price.strip() if price else "N/A"
                })
            
            # Handle Pagination safely
            next_button = page.locator("a.next")
            if await next_button.count() > 0 and await next_button.is_visible():
                await next_button.click()
                await page.wait_for_timeout(1500)  # Gentle delay to prevent blocking
                page_number += 1
            else:
                break  # No more pages
                
        await browser.close()
        
        # Process and save collected data using Pandas
        df = pd.DataFrame(all_products)
        df.to_csv("products.csv", index=False)
        print(f"Successfully scraped {len(all_products)} products to products.csv!")

if __name__ == "__main__":
    asyncio.run(scrape_products())

```