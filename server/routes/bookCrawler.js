const express = require('express');
const router = express.Router();
const {
  getCategories,
  getPageLinks,
  getBookData,
  getExtraCategories,
} = require('../helpers/bookCrawler');

router.get('/categories', getCategories);
router.get('/getPageLinks', getPageLinks);
router.get('/getBookData', getBookData);
router.get('/subCategories', getExtraCategories);

module.exports = router;
