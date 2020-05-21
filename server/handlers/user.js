const db = require('../models');
const jwt = require('jsonwebtoken');

exports.login = async (req, res, next) => {
  try {
    const user = await db.User.findOne({ email: req.body.email.toLowerCase() });
    let { id } = user;
    let isMatch = await user.comparePassword(req.body.password);
    if (isMatch) {
      let token = jwt.sign(
        {
          id,
        },
        process.env.SECRET_KEY
      );
      return res.status(200).json({
        token,
      });
    } else {
      return next({ status: 400, message: 'Invalid Email/Password' });
    }
  } catch (err) {
    next({
      message:
        'Something went wrong well trying to log in, please try again later',
    });
  }
};

exports.register = async (req, res, next) => {
  try {
    const user = await db.User.create({
      ...req.body,
      email: req.body.email.toLowerCase(),
    });
    let { id } = user;
    let token = jwt.sign(
      {
        id,
      },
      process.env.SECRET_KEY
    );
    res.status(200).json({
      token,
    });
  } catch (err) {
    if (err === 11000) {
      next({ message: 'Sorry that email is taken' });
    }
    next({
      message:
        'Something went wrong well trying to register, please try again later',
    });
  }
};
