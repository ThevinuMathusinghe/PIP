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

exports.addSavedBook = async (req, res, next) => {
  try {
    const id = res.locals.id;
    let user = await db.User.findOne({ _id: id });
    if (user != null) {
      let savedBooks = user.savedBooks;
      if (savedBooks.indexOf(req.body.newBookId) < 0) {
        savedBooks.push(req.body.newBookId);
        user.savedBooks = savedBooks;
        await user.save();
      }
      user = await db.User.findOne({ _id: id }).populate("savedBooks")
      res.json({ user });
    } else {
      next({ message: "You do not have permission to do that" })
    }
  } catch (err) {
    console.log(err);
    next({ message: "Something went wrong, please try again later" });
  }
}

exports.addSavedLogo = async (req, res, next) => {
  try {
    const id = res.locals.id;
    let user = await db.User.findOne({ _id: id });
    if (user != null) {
      let savedLogos = user.savedLogos;
      if (savedLogos.indexOf(req.body.newLogoId) < 0) {
        savedLogos.push(req.body.newLogoId);
        user.savedLogos = savedLogos;
        await user.save();
      }
      user = await db.User.findOne({ _id: id }).populate("savedLogos");
      res.json({ user })
    } else {
      next({ message: "You do not have permission to do that" })
    }
  } catch (err) {
    console.log(err);
    next({ message: "Something went wrong, try again later" })
  }
}

exports.getUserSavedLogos = async (req, res, next) => {
  try {
    const id = res.locals.id;
    const user = await db.User.findOne({ _id: id }).populate('savedLogos');
    res.json({ savedLogos: user.savedLogos })
  } catch (err) {
    console.log(err)
    next({ message: "Something went wrong, please try again later" })
  }
}

exports.getUserSavedBooks = async (req, res, next) => {
  try {
    const id = res.locals.id;
    const user = await db.User.findOne({ _id: id }).populate("savedBooks")
    res.json({ savedBooks: user.savedBooks });
  } catch (err) {
    console.log(err);
    next({ mesage: "Something went wrong, please try again later" })
  }
}
