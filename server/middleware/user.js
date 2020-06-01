const db = require('../models');
const jwt = require('jsonwebtoken');

exports.checkJwt = async (req, res, next) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const { id } = await jwt.verify(token, process.env.SECRET_KEY);
    if (id != null) {
      const user = await db.User.findOne({ _id: id });
      if (user != null) {
        res.locals.id = id
        next();
      } else {
        return next({ message: "You do not have permission" })
      }
    }
    else {
      return next({ message: "You do not have permission" })
    }
  } catch (err) {
    console.log(err)
    next({ message: "Something went wrong, please try again later" });
  }
}