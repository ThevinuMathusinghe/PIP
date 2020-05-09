const mongoose = require('mongoose');

const logoSchema = new mongoose.Schema({
    title:{
        type: String,
        required:true
    },
    description: {
        type: String,
    },
    categories: {
        type: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'Categories',
            }
        ]
    },
    information: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Information',
    },
    revenue: {
        type: Number,
    },
    apartmentSuite: {
        type: String,
    },
    streetAddress: {
        type: String,
    },
    suburb: {
        type: String,
    },
    city: {
        type: String,
    },
    postCode: {
        type: String,
    },
    country: {
        type: String,
    },
    countryCode: {
        type: String,
    },
    phoneNumber: {
        type: String,
    },
    website: {
        type:String,
    },
    companyFounded: {
        type: String,
    },
    reviews: {
        type: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "ReviewsCompany "
            }
        ]
      
    }
})
module.exports = mongoose.model('Logos',logoSchema);
