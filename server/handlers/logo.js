const db = require('../models');
const vision = require('@google-cloud/vision');
const fs = require('fs');
const path = require('path');

exports.identify = async (req, res, next) => {
  try {
    // Code the idenifying of the image
    var name = req.body.name;
    var img = req.body.image;
    var realFile = Buffer.from(img, 'base64');
    fs.writeFile(name, realFile, function (err) {
      if (err) console.log(err);
    });

    // Once there get the url and run through the google cloud vision api
    const client = new vision.ImageAnnotatorClient();
    const [result] = await client.logoDetection(`./${name}`);
    const logos = result.logoAnnotations;
    let foundLogos = [];
    logos.forEach((logo) => {
      foundLogos.push(logo.description);
    });

    res.send({ logos: foundLogos });
  } catch (err) {
    next({ message: 'Something went wrong, try again later' });
  }
};

exports.singleLogo = async (req, res, next) => {
  try {
    // Get a single logo
  } catch (err) {
    next({ message: 'Something went wrong, please try again later' });
  }
};
