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
    const secondPageLinks = fs.readFileSync(
      path.join(__dirname, "./links/bookSecondPageLinks.txt"),
      "utf-8"
    );
    let secondLinks = secondPageLinks.split(",");

    const browser = await puppeteer.launch({ headless: false });

    for (var i = 0; i < secondLinks.length; i++) {
      var oldLink = "";
      var newLink = secondLinks[i];
      const interval = setInterval(() => {
        if (newLink != oldLink) {
          oldLink = new String(newLink);
          (async () => {
            // Open the page
            const page = await browser.newPage();
            await page.setViewport({ width: 1980, height: 1080 });
            await page.goto(newLink);
            // Save the link to a file
            // Get the old file
            const rawLinks = fs.readFileSync(
              path.join(__dirname, "./links/bookPageLinks.txt"),
              "utf-8"
            );
            // Get the data
            let links = rawLinks.split(",");
            // Append the new data
            links.push(newLink);
            // save
            fs.writeFileSync(
              path.join(__dirname, "./links/bookPageLinks.txt"),
              links
            );
            // get the link for the next page and add to a variable
            const bookPage = await page.evaluate(() => {
              let links = document.querySelectorAll(
                "div.a-text-center li.a-last"
              );
              let linksArray = Array.from(links);
              var linksData;
              for (var i = 0; i < linksArray.length; i++) {
                var linksArray2 = Array.from(linksArray[i].childNodes);
                for (var j = 0; j < linksArray2.length; j++) {
                  if (linksArray2[j].nodeName == "A") {
                    linksData = linksArray2[j].href;
                  }
                }
              }
              return linksData;
            });
            if (bookPage == undefined) {
              clearInterval(interval);
            } else {
              // Loop through with the new link
              newLink = bookPage;
            }
            page.close();
          })();
        }
      }, 1000);
    }
  } catch (err) {
    console.log(err);
    return res.json({ error: "Something has gone wrong", status: 400 });
  }
};
