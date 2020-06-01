const express = require("express")
const router = express.Router();
const { login, register, addSavedBook, addSavedLogo } = require("../handlers/user")
const { checkJwt } = require('../middleware/user');

router.post('/login', login);

router.post('/register', register);

router.post('/saved/book', checkJwt, addSavedBook)

router.post('/saved/logo', checkJwt, addSavedLogo)

module.exports = router