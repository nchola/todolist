const mongoose = require('mongoose');

const todoSchema = new mongoose.Schema({
  title: { type: String, required: true },
  category: { type: String, default: 'All' },
  completed: { type: Boolean, default: false },
  labels: { type: [String], default: [] }, // New field for labels
});

module.exports = mongoose.model('Todo', todoSchema);
