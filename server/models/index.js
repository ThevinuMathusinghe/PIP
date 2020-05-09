const mongoose = require('mongoose');
mongoose.set('useCreateIndex', true);
mongoose.set('useFindAndModify', false);
const databaseUrl = 'mongodb://localhost:27017/pip';
mongoose
  .connect(databaseUrl, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log('Connected');
  })
  .catch((err) => {
    console.log(err);
  });

module.exports.User = require('./user');

module.exports.Information = require('./information');

module.exports.Logo = require('./logo');

module.exports.ReviewsCompany = require('./reviewscompany');

module.exports.Categories = require('./categories');
