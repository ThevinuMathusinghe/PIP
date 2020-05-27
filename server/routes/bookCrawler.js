const express = require("express");
const router = express.Router();
const {
  getCategories,
  getPageLinks,
  getBookData,
} = require("../helpers/bookCrawler");

router.get("/categories", getCategories);
router.get("/getPageLinks", getPageLinks);
router.get("/getBookData", getBookData);

module.exports = router;
