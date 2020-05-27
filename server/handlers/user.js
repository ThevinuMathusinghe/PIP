const db = require('../models');
const jwt = require('jsonwebtoken');

exports.login = async (req, res, next) => {
  try {
    if (req.body.email == '' || req.body.password == '') {
      next({ message: 'Please enter your email address and password' });
    }
    const user = await db.User.findOne({
      email: req.body.email.toLowerCase().trim(),
    });
    if (user == null) {
      next({ message: 'That email does not belong to an account' });
    }
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
    // Check that all the fields are filled out
    if (
      req.body.firstName == '' ||
      req.body.lastName == '' ||
      req.body.email == '' ||
      req.body.password == ''
    ) {
      next({ message: 'Please fill in all the fields' });
    }
    const user = await db.User.create({
      firstName: req.body.firstName.trim(),
      lastName: req.body.lastName.trim(),
      email: req.body.email.toLowerCase().trim(),
      password: req.body.password.trim(),
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
    console.log(err);
    if (err.code === 11000) {
      next({ message: 'Sorry that email is taken' });
    }
    next({
      message:
        'Something went wrong well trying to register, please try again later',
    });
  }
};
