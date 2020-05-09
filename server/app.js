require('dotenv').config();
var express = require('express');
var bodyParser = require('body-parser');
var fs = require('fs');
var app = express();
const { Storage } = require('@google-cloud/storage');
const path = require('path');
const storage = new Storage({
  keyFilename: path.join(
    __dirname,
    './personal-information-ab365-a93f4d7a7154.json'
  ),
  projectId: 'personal-information-ab365',
});
const vision = require('@google-cloud/vision');
const db = require('./models');

const bucket = storage.bucket('compx241-pip');

app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));

app.get('/login', async (req, res, next) => {
  try {
    const user = await db.User.create({
      ...req.body,
    });
    res.send('Success');
  } catch (err) {
    console.log(err);
    res.json({ err });
  }
});

app.get('/', (req, res, next) => {
  try {
    res.json('Welcome');
  } catch (err) {
    console.log(err);
    res.json(err);
  }
});

app.post('/image', async (req, res, next) => {
  var name = req.body.name;
  var img = req.body.image;
  var realFile = Buffer.from(img, 'base64');
  fs.writeFile(name, realFile, function (err) {
    if (err) console.log(err);
  });

  // Send the file to the google cloud bucket
  const imagePath = `./${name}`;

  await bucket.upload(imagePath, {
    gzip: true,
    metadata: {
      cacheControl: 'public, max-age=31536000',
    },
    resumable: false,
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
});

app.listen(3000, () => {
  console.log('the server has started');
});
