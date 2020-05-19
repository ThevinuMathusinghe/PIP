const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
const db = require('../models');

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
        fs.writeFileSync(
          path.join(__dirname, './links/companyLinks.txt'),
          companyLinksFull
        );
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

exports.getCompanyData = async (req, res, next) => {
  try {
    console.log('started');
    const rawLinks = fs.readFileSync(
      path.join(__dirname, './links/companyLinks.txt'),
      'utf-8'
    );
    let links = rawLinks.split(',');

    const browser = await puppeteer.launch({ headless: false });

    let companyData = [];
    let count = 0;

    const interval = setInterval(async () => {
      console.log(count);
      if (count >= 2) {
        clearInterval(interval);
        // browser.close();
        next();
      } else {
        for (let i = count * 5; i < count * 5 + 5; i++) {
          (async () => {
            try {
              const page = await browser.newPage();
              await page.setViewport({ width: 1980, height: 1080 });
              await page.goto(links[i], { waitUntil: 'load', timeout: 0 });

              //Find the data in the links
              const singleData = await page.evaluate(() => {
                //Title
                var title = document.querySelectorAll('h1')[0].innerText;

                //Description
                var description = document.querySelectorAll(
                  'div.ci-content-fullwidth p'
                );
                var descriptionArray = Array.from(description);
                var descriptionString = descriptionArray[1].innerText;

                //Revenue
                var revenue = document.querySelectorAll('td');
                var revenueArray = Array.from(revenue);
                var revenueData = '';
                for (var i = 0; i < revenueArray.length; i++) {
                  if (revenueArray[i].innerText == 'Revenue') {
                    revenueData = revenueArray[i + 1].innerText;
                  }
                }

                //PhoneNumber
                var phoneNumber = document.querySelectorAll('td');
                var phoneNumberArray = Array.from(phoneNumber);
                var phoneNumberData = '';
                for (var i = 0; i < phoneNumberArray.length; i++) {
                  if (
                    phoneNumberArray[i].innerText == 'Phone' ||
                    phoneNumberArray[i].innerText == 'Freecall'
                  ) {
                    phoneNumberData = phoneNumberArray[i + 1].innerText;
                  }
                }

                //Website
                var website = document.querySelectorAll('td');
                var websiteArray = Array.from(website);
                var websiteData = '';
                for (var i = 0; i < websiteArray.length; i++) {
                  if (websiteArray[i].innerText == 'Website') {
                    websiteData = websiteArray[i + 1].innerText;
                  }
                }

                //INFORMATION

                //Title & Details
                var informationTitle = document.querySelectorAll('tr');
                var informationTitleArray = Array.from(informationTitle);
                var informationTitleDataArray = [];
                for (var i = 0; i < informationTitleArray.length; i++) {
                  var childNodeArray = Array.from(
                    informationTitleArray[i].childNodes
                  );
                  for (var j = 0; j < childNodeArray.length; j++) {
                    if (childNodeArray[j].nodeName == 'TD') {
                      if (
                        childNodeArray[j].childNodes.length > 0 &&
                        childNodeArray[j].childNodes[0].nodeName == 'IMG'
                      ) {
                        if (j + 2 < childNodeArray.length) {
                          informationTitleDataArray.push(
                            childNodeArray[j + 2].childNodes[0].innerText
                          );

                          childNodeArray[j + 2].childNodes[0].click();
                        }
                      }
                    }
                  }
                }
                //Rating
                var informationDetails = document.querySelectorAll(
                  'td.smallerFont'
                );
                var informationDetailsArray = Array.from(informationDetails);
                var informationDetailsDataArray = [];
                var ratingArray = [];
                for (var i = 0; i < informationDetailsArray.length; i++) {
                  var detailesChildNodeArray = Array.from(
                    informationDetailsArray[i].childNodes
                  );
                  for (var j = 3; j < detailesChildNodeArray.length; j += 4) {
                    informationDetailsDataArray.push(
                      detailesChildNodeArray[j].innerText
                    );
                    if (
                      informationDetailsArray[i].className ==
                      'smallerFont companyPraise'
                    ) {
                      ratingArray.push('praise');
                    } else if (
                      informationDetailsArray[i].className ==
                      'smallerFont companyCriticism'
                    ) {
                      ratingArray.push('criticism');
                    } else {
                      ratingArray.push('information');
                    }
                  }
                }

                //Address
                var address = document.querySelectorAll('td');
                var addressArray = Array.from(address);
                var addressData = '';
                for (var i = 0; i < addressArray.length; i++) {
                  if (addressArray[i].innerText == 'Address') {
                    addressData = addressArray[i + 1].innerText;
                  }
                }

                return {
                  title,
                  description: descriptionString,
                  revenue: revenueData,
                  address: addressData,
                  phoneNumber: phoneNumberData,
                  website: websiteData,
                  informationTitleDataArray,
                  informationDetailsDataArray,
                  ratingArray,
                };
              });

              const infomationTitles = singleData.informationTitleDataArray;
              const informationDetails = singleData.informationDetailsDataArray;
              const informationRatings = singleData.ratingArray;

              delete singleData.informationTitleDataArray;
              delete singleData.informationDetailsDataArray;
              delete singleData.ratingArray;
              // Add to the database
              const logo = await db.Logo.create(singleData);

              let infomationData = [];
              infomationTitles.forEach(async (title, i) => {
                try {
                  infomationData.push({
                    title,
                    details: informationDetails[i],
                    rating: informationRatings[i],
                  });
                } catch (err) {
                  console.log(err);
                }
              });

              const informations = await db.Information.insertMany(
                infomationData
              );
              logo.information = informations;
              await logo.save();

              await page.close();
            } catch (err) {
              console.log(err);
            }
          })();
        }
        count += 1;
      }
    }, 4000);
  } catch (err) {
    console.log(err);
  }
};
