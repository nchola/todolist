const Todo = require('../models/Todo');
const mongoose = require('mongoose');

// Get all todos
exports.getAllTodos = async (req, res) => {
  try {
    const todos = await Todo.find();
    res.json(todos);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.createTodo = async (req, res) => {
  const todo = new Todo({
    title: req.body.title,
    category: req.body.category || 'All',
    labels: req.body.labels || [], // Accept labels during creation
  });

  try {
    const newTodo = await todo.save();
    res.status(201).json(newTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};


// Update a todo
exports.updateTodo = async (req, res) => {
  try {
    const todo = await Todo.findById(req.params.id);
    if (!todo) return res.status(404).json({ message: 'Todo not found' });

    todo.title = req.body.title || todo.title;
    todo.completed = req.body.completed != null ? req.body.completed : todo.completed;
    todo.labels = req.body.labels || todo.labels;
    res.json(updatedTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Delete a todo
exports.deleteTodo = async (req, res) => {
  const id = req.params.id;

  // Validate ID before performing operations in MongoDB
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid Todo ID' });
  }

  try {
    const todo = await Todo.findById(id);
    if (!todo) return res.status(404).json({ message: 'Todo not found' });

    await todo.deleteOne();
    res.status(200).json({ message: 'Todo deleted' });
  } catch (err) {
    console.error(`Error deleting todo: ${err.message}`);
    res.status(500).json({ message: 'Failed to delete todo' });
  }
};

// Get todos by category
exports.getTodosByCategory = async (req, res) => {
  const category = req.query.category || 'All';
  try {
    const todos = await Todo.find({ category });
    res.json(todos);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
