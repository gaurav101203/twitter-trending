from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import time
import datetime
import pymongo
import requests

# Configure ProxyMesh
PROXY = "http://gaurav10:qweasd147258@us-ca.proxymesh.com:31280"

chrome_options = Options()
chrome_options.add_argument(f'--proxy-server={PROXY}')
chrome_options.add_argument("--headless")

# Create a new instance of the Chrome driver
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

# Login to X.com
def login_to_x(driver, username, password): 
    driver.get('https://x.com/login') 
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.NAME, 'text'))) 
    user_input = driver.find_element(By.NAME, 'text') 
    user_input.send_keys(username) 
    user_input.send_keys(Keys.RETURN) 
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.NAME, 'password'))) 
    pass_input = driver.find_element(By.NAME, 'password') 
    pass_input.send_keys(password) 
    pass_input.send_keys(Keys.RETURN) 
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, '//nav')))

# Fetch trending topics
def get_trending_topics(driver):
    driver.get('https://x.com/home')
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, '//section[@aria-labelledby="accessible-list-0"]')))
    
    # Locate the "What's Happening" section
    trends_section = driver.find_element(By.XPATH, '//div[@aria-label="Timeline: Trending now"]') 
    trends = trends_section.find_elements(By.XPATH, './/span[contains(text(), "#")]')
    
    # Debug: Print the trends
    print("Trends found:", [trend.text for trend in trends])
    
    top_5_trends = [trend.text for trend in trends if trend.text and trend.text.startswith('#')] 
    top_5_trends = top_5_trends[:]
    return top_5_trends

# MongoDB setup
client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client['twitter_trends']
collection = db['trending_topics']

def store_trending_topics(trends, ip_address):
    unique_id = str(datetime.datetime.now().timestamp())
    
    # Handle cases where there are fewer than 5 trends
    trends.extend([""] * (5 - len(trends)))
    
    record = {
        "_id": unique_id,
        "trend1": trends[0],
        "trend2": trends[1],
        "trend3": trends[2],
        "trend4": trends[3],
        "trend5": trends[4],
        "datetime": datetime.datetime.now(),
        "ip_address": ip_address
    }
    try:
        collection.insert_one(record)
    except pymongo.errors.ServerSelectionTimeoutError as err:
        print("MongoDB connection error:", err)

# Main logic
def main(username, password):
    try:
        login_to_x(driver, username, password)
        trending_topics = get_trending_topics(driver)
        ip_address = requests.get('https://api.ipify.org').text
        store_trending_topics(trending_topics, ip_address)
        return trending_topics, ip_address
    finally:
        driver.quit()

if __name__ == "__main__":
    # Replace with your Twitter credentials
    USERNAME = "GauravYadav1012"
    PASSWORD = "qweasd147258"
    main(USERNAME, PASSWORD)
