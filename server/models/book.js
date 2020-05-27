const mongoose = require("mongoose");

const bookSchema = new mongoose.Schema({
  title: {
    type: String,
  },
  author: {
    type: String,
  },
  publishDate: {
    type: Date,
  },
  rating: {
    type: String,
  },
  image: {
    type: String,
  },
  link: {
    type: String,
  },
});
module.exports = mongoose.model("Book", bookSchema);
