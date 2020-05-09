const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

exports.getCategories = async (req, res, next) => {
  try {
    console.log('Started');
    const browser = await puppeteer.launch({ headless: false });
    const page = await browser.newPage();
    await page.setViewport({ width: 1980, height: 1080 });
    await page.goto(req.body.url);

    const categoriesLinks = await page.evaluate(() => {
      let links = document.querySelectorAll('p a.green');
      let linksArray = Array.from(links);
      linksArray = linksArray.map((link) => {
        return link.href;
      });

      return linksArray;
    });

    fs.writeFileSync(path.join(__dirname, './links/links.js'), categoriesLinks);
    browser.close();
    next();
    console.log('done');
  } catch (err) {
    console.log(err);
    return res.json({ error: 'Something has gone wrong', status: 400 });
  }
};

exports.getCompanyLinks = async (req, res, next) => {
  try {
    console.log('started');
    // Get the links from the file
    const rawLinks = fs.readFileSync(
      path.join(__dirname, './links/links.txt'),
      'utf-8'
    );
    let links = rawLinks.split(',');

    const browser = await puppeteer.launch({ headless: false });

    // Loop
    let companyLinksFull = [];
    let count = 0;
    const interval = setInterval(() => {
      console.log(count);
      if (count >= 5) {
        // Write to a text file
        fs.writeFileSync(path.join(__dirname, "./links/companyLinks.txt"), companyLinksFull)
        clearInterval(interval);
        browser.close();
        next();
      } else {
        for (let i = count * 5; i < count * 5 + 5; i++) {
          (async () => {
            try {
              const page = await browser.newPage();
              await page.setViewport({ width: 1980, height: 1080 });
              await page.goto(links[i]);

              // Find the other links inside the links page
              const companyLinks = await page.evaluate(() => {
                var links = document.querySelectorAll('.column-2');
                var linksArray = Array.from(links);

                linksArray = linksArray.filter((link, i) => {
                  return i != 0;
                });

                linksArray = linksArray.map((link) => {
                  return link.childNodes[0].href;
                });
                return linksArray;
              });
              companyLinksFull.push(...companyLinks);
              page.close();
            } catch (err) {
              console.log(err);
            }
          })();
        }
        count += 1;
      }
    }, 5000);
  } catch (err) {
    console.log(err);
    res.json({ error: 'Something went wrong', status: 400 });
  }
};
