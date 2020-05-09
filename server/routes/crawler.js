const express = require('express');
const router = express.Router();
const { getCategories, getCompanyLinks } = require('../helpers/crawler');

router.get('/categories', getCategories);

router.get('/companyLinks', getCompanyLinks);

module.exports = router;
