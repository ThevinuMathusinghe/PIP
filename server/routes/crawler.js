const express = require('express');
const router = express.Router();
const { getCategories, getCompanyLinks, getCompanyData } = require('../helpers/crawler');

router.get('/categories', getCategories);

router.get('/companyLinks', getCompanyLinks);

router.get('/singleLogo', getCompanyData)

module.exports = router;
