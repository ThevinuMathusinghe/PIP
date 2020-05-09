const mongoose = require('mongoose');

const categoriesSchema = new mongoose.Schema({
    name: {
        type: String,
    },
    subCategories: {
        type: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'Categories',
            }
        ]
    } 
})

module.exports = mongoose.model('Categories',categoriesSchema);
