const vision = require('@google-cloud/vision');
const fs = require('fs');
const path = require('path');
const db = require('../models');

exports.getBooks = async (req, res, next) => {
  try {
    var name = req.body.name;
    var img = req.body.image;
    var realFile = Buffer.from(img, 'base64');
    fs.writeFile(name, realFile, function (err) {
      if (err) console.log(err);
    });

    // Once there get the url and run through the google cloud vision api
    const client = new vision.ImageAnnotatorClient();
    const [result] = await client.textDetection(`./${name}`);
    const textLabels = result.textAnnotations;
    const text = textLabels
      .map((text) => {
        return text.description;
      })
      .filter((t, i) => {
        return i != 0;
      });

    // match the search results
    const bookRegex = text.map((t) => {
      return new RegExp(escapeRegex(t), 'gi');
    });

    let promiseArray = [];
    bookRegex.forEach((word) => {
      const foundBooks = db.Book.find({
        $or: [{ title: word }, { author: word }],
      });
      promiseArray.push(foundBooks);
    });

    let matchedBook = {};
    const allMatchesBooks = await Promise.all(promiseArray);
    allMatchesBooks.forEach((bookArray) => {
      bookArray.forEach((book) => {
        if (matchedBook[book._id] != null) {
          matchedBook[book._id]++;
        } else {
          matchedBook[book._id] = 1;
        }
      });
    });

    let high = 0;
    Object.keys(matchedBook).forEach((key) => {
      if (matchedBook[key] > high) {
        high = matchedBook[key];
      }
    });

    const displayedBooks = Object.keys(matchedBook).filter((key) => {
      return matchedBook[key] == high;
    });

    const books = await db.Book.find({ _id: displayedBooks });
    res.json({ books });
  } catch (err) {
    console.log(err);
    next({ message: 'Something went wrong, please try again later' });
  }
};

const escapeRegex = (text) => {
  return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
};
