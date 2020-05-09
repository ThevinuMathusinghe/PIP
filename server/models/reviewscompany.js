const mongoose = require('mongoose');

const reviewscompanySchema = new mongoose.Schema({
    date: {
        type: Date,
    },
    text: {
        type: String,
    },
    rating: {
        type: Number,
    },
    from: {
        type: String,
    },
    source: {
        type: String,
    },
})

module.exports = mongoose.model('ReviewsCompany', reviewscompanySchema);
