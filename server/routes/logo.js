const express = require('express')
const router = express.Router();
const { identify, singleLogo } = require('../handlers/logo')

router.post("/identify", identify)

router.get('/:id', singleLogo)



module.exports = router;