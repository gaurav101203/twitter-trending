const { Builder, By, Key, until } = require('selenium-webdriver');
const MongoClient = require('mongodb').MongoClient;
const axios = require('axios');
const express = require('express');
const bodyParser = require('body-parser');
const chrome = require('selenium-webdriver/chrome');
const path = require('path');
const cors = require('cors');

const PROXY = "http://gaurav10:qweasd147258@us-ca.proxymesh.com:31280";
const MONGO_URI = "mongodb+srv://gaurav:qweasd147258@cluster0.if4ft.mongodb.net/";
const DB_NAME = "twitter_trends";
const USERNAME = "GauravYadav1012"; // Predefined Twitter username
const PASSWORD = "qweasd147258"; // Predefined Twitter password
const EMAIL = "yadavgaurav101203@gmail.com";
const driverPath = "./chromedriver"; // Path to the ChromeDriver
const chromePath = "/opt/chrome/chrome-linux64/chrome";

// MongoDB setup
let db;
MongoClient.connect(MONGO_URI)
    .then(client => {
        db = client.db(DB_NAME);
        console.log("Connected to MongoDB");
    })
    .catch(err => console.error("MongoDB connection error:", err));

// Login to Twitter
async function loginToTwitter(driver, username,email, password) {
    await driver.get("https://x.com/login");
    await driver.wait(until.elementLocated(By.name("text")), 30000);
    const usernameInput = await driver.findElement(By.name("text"));
    await usernameInput.sendKeys(username, Key.RETURN);

    // Check if email input exists
    try {
        await driver.wait(until.elementLocated(By.name("text")), 2000);
        const emailInput = await driver.findElement(By.name("text"));
        await emailInput.sendKeys(email, Key.RETURN);
    } catch (err) {
        console.log("Email input not required, proceeding to password.");
    }

    await driver.wait(until.elementLocated(By.name("password")), 30000);
    const passwordInput = await driver.findElement(By.name("password"));
    await passwordInput.sendKeys(password, Key.RETURN);

    await driver.wait(until.elementLocated(By.xpath("//nav")), 30000);
}

// Fetch trending topics from the Explore page
async function getTrendingTopics(driver, retries=3) {
    for (let i = 0; i < retries; i++) {
    await driver.get("https://x.com/explore/tabs/trending");
    await driver.wait(until.elementLocated(By.xpath('//section[@aria-labelledby="accessible-list-0"]')), 200000);

    const trendsSection = await driver.findElement(By.xpath('//section[@aria-labelledby="accessible-list-0"]'));
    const trendElements = await trendsSection.findElements(By.xpath('.//span[contains(text(), "#")]'));

    const trends = [];
    for (let trendElement of trendElements) {
        const text = await trendElement.getText();
        if (text.startsWith("#")) trends.push(text);
    }

    // Debug Output
    console.log("Trends found:", trends);
    if (trends.length > 0) { return trends; } else { console.warn(`Retrying to fetch trends... Attempt ${i + 2}`); }
}
    return trends;
}

// Store trending topics in MongoDB
async function storeTrendingTopics(trends, ipAddress) {
    const collection = db.collection("trending_topics");
    const record = {
        trends,
        ipAddress,
        datetime: new Date().toISOString()
    };

    try {
        await collection.insertOne(record);
        console.log("Trends stored in MongoDB");
    } catch (err) {
        console.error("Error storing trends in MongoDB:", err);
    }
}

// Main function
async function fetchTrends() {
    const options = new chrome.Options()
        .setChromeBinaryPath(chromePath) 
        .addArguments('--headless') .addArguments('--disable-gpu') .addArguments('--no-sandbox') .addArguments('--disable-dev-shm-usage') .addArguments('--remote-debugging-port=9222') .addArguments('--window-size=1920,1080');
        // .addArguments(`--proxy-server=${PROXY}`);

        const service = new chrome.ServiceBuilder(driverPath); // Correct instantiation
        // service.start();  // Start the Chrome service
        const driver = await new Builder().forBrowser("chrome").setChromeOptions(options)
        .setChromeService(service)
        .build();

    try {
        await loginToTwitter(driver, USERNAME,EMAIL, PASSWORD);
        const trends = await getTrendingTopics(driver);
        const ipAddress = (await axios.get("https://api.ipify.org")).data;
        await storeTrendingTopics(trends, ipAddress);

        return { trends, ipAddress, datetime: new Date().toISOString() };
    } catch (err) {
        console.error("Error:", err);
        throw new Error("Failed to fetch Twitter trends.");
    } finally {
        await driver.quit();
    }
}

// Express App Setup
const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(express.static('twitter-trends-frontend')); // Ensure `index.html` is placed in the `public` folder

app.post('/fetch-trends', async (req, res) => {
    try {
        const { trends, ipAddress, datetime } = await fetchTrends();
        res.json({ trends, ipAddress, datetime });
    } catch (error) {
        console.error("Error in fetchTrends:", error);
        res.status(500).json({ message: error.message });
    }
});

// Start Server
const PORT = 8080;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
