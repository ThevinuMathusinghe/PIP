const express = require("express");
const router = express.Router();
const { getCategories, getPageLinks } = require("../helpers/bookCrawler");

router.get("/categories", getCategories);
router.get("/getPageLinks", getPageLinks);

module.exports = router;
