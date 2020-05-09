const mongoose = require('mongoose');

const informationSchema = new mongoose.Schema({
    title: {
        type: String, 
        required: true
    },
    details: {
        type: String,
    },
    rating: {
        type: String,
        required: true
    }
})

module.exports = mongoose.model('Information',informationSchema);