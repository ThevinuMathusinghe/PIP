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
      path.join(__dirname, "./links/bookPageLinks.txt"),
      "utf-8"
    );
    let secondLinks = secondPageLinks.split(",");

    const browser = await puppeteer.launch({ headless: false });

    var oldLink = new Array(29);
    var newLink = secondLinks.map((link) => link); //map loops through and returns the data and saves it in a NEW array
    const interval = setInterval(() => {
      for (var a = 0; a < secondLinks.length; a++) {
        if (newLink[a] != oldLink[a]) {
          oldLink[a] = new String(newLink[a]);
          (async () => {
            try {
              const link = new String(newLink[a]);
              const index = a;

              // Open the page
              const page = await browser.newPage();
              await page.setViewport({ width: 1980, height: 1080 });
              await page.goto(String(link));
              // Save the link to a file
              // Get the old file
              const rawLinks = fs.readFileSync(
                path.join(__dirname, "./links/bookPageLinks.txt"),
                "utf-8"
              );
              // Get the data
              let links = rawLinks.split(",");
              // Append the new data
              links.push(link);
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
                newLink[index] = bookPage;
              }
              page.close();
            } catch (err) {
              console.log(err);
            }
          })();
        }
      }
    }, 1000);
  } catch (err) {
    console.log(err);
    return res.json({ error: "Something has gone wrong", status: 400 });
  }
};

exports.getBookData = async (req, res, next) => {
  try {
    console.log("started");
    const rawLinks = fs.readFileSync(
      path.join(__dirname, "./links/bookPageLinks.txt"),
      "utf-8"
    );
    let links = rawLinks.split(",");

    const browser = await puppeteer.launch({ headless: false });

    let count = 0;

    const interval = setInterval(async () => {
      const pages = await browser.pages();
      if (pages.length <= 10) {
        for (let i = count * 5; i < count * 5 + 5; i++) {
          (async () => {
            try {
              const page = await browser.newPage();
              await page.setViewport({ width: 1980, height: 1080 });
              await page.goto(links[i], { waitUntil: "load", timeout: 0 });

              //Find the data in the links
              const bookData = await page.evaluate(() => {
                let div = document.querySelectorAll("div.sg-col-inner");
                let divArray = Array.from(div);
                var dateArray = [];
                var titleArray = [];
                var authorArray = [];
                var ratingArray = [];
                var linkArray = [];
                for (var i = 7; i < divArray.length; i += 8) {
                  ///DATE///////////////////////////////////////////////////////////////////////////
                  if (
                    divArray[i].childNodes[1] == undefined ||
                    divArray[i].childNodes[1].childNodes[3] == undefined
                  ) {
                    dateArray.push("");
                  } else {
                    if (
                      divArray[i].childNodes[1].childNodes[3].childNodes
                        .length >= 5 &&
                      divArray[i].childNodes[1].childNodes[3].childNodes[
                        divArray[i].childNodes[1].childNodes[3].childNodes
                          .length - 1
                      ].className ==
                        "a-size-base a-color-secondary a-text-normal"
                    ) {
                      dateArray.push(
                        divArray[i].childNodes[1].childNodes[3].childNodes[
                          divArray[i].childNodes[1].childNodes[3].childNodes
                            .length - 1
                        ].innerText
                      );
                    } else {
                      dateArray.push("");
                    }
                  }
                  ///AUTHOR///////////////////////////////////////////////////////////////////////////
                  if (
                    divArray[i].childNodes[1] == undefined ||
                    divArray[i].childNodes[1].childNodes[3] == undefined ||
                    divArray[i].childNodes[1].childNodes[3].childNodes[1] ==
                      undefined
                  ) {
                    authorArray.push("");
                  } else {
                    if (
                      divArray[i].childNodes[1].childNodes[3].childNodes[1]
                        .className == "a-size-base"
                    ) {
                      authorArray.push(
                        divArray[i].childNodes[1].childNodes[3].childNodes[1]
                          .innerText
                      );
                    } else if (
                      divArray[i].childNodes[1].childNodes[3].childNodes[2]
                        .className == "a-size-base a-link-normal"
                    ) {
                      authorArray.push(
                        divArray[i].childNodes[1].childNodes[3].childNodes[2]
                          .innerText
                      );
                    }
                  }

                  ////TITLE//////////////////////////////////////////////////////////////////////////
                  titleArray.push(
                    divArray[i].childNodes[1].childNodes[1].outerText
                  );

                  ///RATING///////////////////////////////////////////////////////////////////////////
                  if (
                    divArray[i].childNodes[3] == undefined ||
                    divArray[i].childNodes[3].childNodes[1] == undefined ||
                    divArray[i].childNodes[3].childNodes[1].childNodes[1] ==
                      undefined
                  ) {
                    ratingArray.push("");
                  } else {
                    ratingArray.push(
                      divArray[i].childNodes[3].childNodes[1].childNodes[1]
                        .ariaLabel
                    );
                  }

                  ///LINKS///////////////////////////////////////////////////////////////////////
                  linkArray.push(
                    divArray[i].childNodes[1].childNodes[1].childNodes[1].href
                  );
                }

                ///IMAGE//////////////////////////////////////////////////////////////////////////
                let image = document.querySelectorAll("div.a-section");
                let imageArray = Array.from(image);
                var imageClassArray = [];
                for (var i = 1; i < imageArray.length; i++) {
                  if (
                    imageArray[i].className ==
                    "a-section aok-relative s-image-fixed-height"
                  ) {
                    imageClassArray.push(
                      imageArray[i].childNodes[1].currentSrc
                    );
                  }
                }
                return {
                  titleArray,
                  authorArray,
                  dateArray,
                  ratingArray,
                  imageClassArray,
                };
                // console.log(titleArray);
                // console.log(authorArray);
                // console.log(dateArray);
                // console.log(ratingArray);
                // console.log(imageClassArray);
              });

              const bookTitles = bookData.titleArray;
              const bookAuthors = bookData.authorArray;
              const bookDates = bookData.dateArray;
              const bookRatings = bookData.ratingArray;
              const bookImages = bookData.imageClassArray;
              const bookLinks = bookData.linkArray;

              // Add to the database
              const book = await db.Book.create(bookData);

              let infomationData = [];
              bookTitles.forEach((titleArray, i) => {
                try {
                  infomationData.push({
                    title: titleArray,
                    author: bookAuthors[i],
                    publishDate: bookDates[i],
                    rating: bookRatings[i],
                    image: bookImages[i],
                    link: bookLinks[i],
                  });
                } catch (err) {
                  console.log(err);
                }
              });
              await db.Book.insertMany(infomationData);

              await page.close();
            } catch (err) {
              console.log(err);
            }
          })();
        }
        count += 1;
      }
    }, 1000);
  } catch (err) {
    console.log(err);
  }
};
