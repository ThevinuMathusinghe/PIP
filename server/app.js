require('dotenv').config();
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
const crawlerRoutes = require('./routes/crawler');
const errorHandler = require('./handlers/error');
const userRoutes = require('./routes/user');
const cors = require('cors');
const logoRoutes = require('./routes/logo');
const bookCrawlerRoutes = require('./routes/bookCrawler');


app.use(cors());
app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));

app.use('/crawler', crawlerRoutes);
app.use('/user', userRoutes);
app.use('/logo', logoRoutes);
app.use('/bookCrawler',bookCrawlerRoutes);

app.get('/', (req, res, next) => {
  try {
    res.json('Welcome');
  } catch (err) {
    console.log(err);
    res.json(err);
  }
});

app.use((req, res, next) => {
  let err = new Error('Not Found');
  err.status = 404;
  next(err);
});

app.use(errorHandler);

app.listen(process.env.PORT, () => {
  console.log('the server has started');
});
