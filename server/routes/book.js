const express = require('express');
const router = express.Router();
const { getBooks } = require('../handlers/book');

router.get('/identify', getBooks);

module.exports = router;
