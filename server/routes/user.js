const express = require("express")
const router = express.Router();
const { login, register, addSavedBook, addSavedLogo, getUserSavedBooks, getUserSavedLogos } = require("../handlers/user")
const { checkJwt } = require('../middleware/user');

router.post('/login', login);

router.post('/register', register);

router.post('/saved/book/add', checkJwt, addSavedBook)

router.post('/saved/logo/add', checkJwt, addSavedLogo);

router.get('/saved/books', checkJwt, getUserSavedBooks);

router.get('/saved/logos', checkJwt, getUserSavedLogos)

module.exports = router