const puppeteer = require("puppeteer");
const fs = require("fs");
const path = require("path");
const db = require("../models");

exports.getCategories = async (req, res, next) => {
  try {
    console.log("started");
    const browser = await puppeteer.launch({ headless: false });
    const page = await browser.newPage();
    await page.setViewport({ width: 1980, height: 1080 });
    await page.goto(req.body.url);

    const categoriesLinks = await page.evaluate(() => {
      let links = document.querySelectorAll("li span a");
      let linksArray = Array.from(links);
      var linkClassArray = [];

      for (var i = 3; i < 35; i++) {
        linkClassArray.push(linksArray[i].href);
      }
      return linkClassArray;
    });

    fs.writeFileSync(
      path.join(__dirname, "./links/bookCategoriesLinks.txt"),
      categoriesLinks
    );
    browser.close();
    next();
    console.log("done");
  } catch (err) {
    console.log(err);
    return res.json({ error: "Something has gone wrong", status: 400 });
  }
};

exports.getPageLinks = async (req, res, next) => {
  try {
    console.log("started");
    // Get the links from the file
    const rawLinks = fs.readFileSync(
      path.join(__dirname, "./links/bookCategoriesLinks.txt"),
      "utf-8"
    );
    let links = rawLinks.split(",");

    const browser = await puppeteer.launch({ headless: false });

    let pageLinks = [];
    let count = 0;
    const interval = setInterval(() => {
      console.log(count);
    }, 5000);
  } catch (err) {
    console.log(err);
    return res.json({ error: "Something has gone wrong", status: 400 });
  }
};
