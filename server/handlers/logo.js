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
    console.log(result);
    const logos = result.logoAnnotations;
    let foundLogos = [];
    logos.forEach((logo) => {
      foundLogos.push(logo.description);
    });

    let foundLogoRegex = [];
    // Search the database for matches
    foundLogos.forEach((logo) => {
      foundLogoRegex.push(new RegExp(escapeRegex(logo), 'gi'));
    });

    const logo = await db.Logo.find({ title: foundLogoRegex }).populate(
      'information'
    );

    // Return the matched data
    res.json({ logo });
  } catch (err) {
    next({ message: 'Something went wrong, try again later' });
  }
};

const escapeRegex = (text) => {
  return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
};
