const mongoose = require('mongoose');

const logoSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },

  information: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Information',
      },
    ],
  },
  revenue: {
    type: String,
  },
  address: {
    type: String,
  },

  phoneNumber: {
    type: String,
  },
  website: {
    type: String,
  },
});

module.exports = mongoose.model('Logos', logoSchema);
