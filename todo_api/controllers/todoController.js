const Todo = require('../models/Todo');
const mongoose = require('mongoose');

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
  });

  try {
    const newTodo = await todo.save();
    res.status(201).json(newTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.updateTodo = async (req, res) => {
  try {
    const todo = await Todo.findById(req.params.id);
    if (!todo) return res.status(404).json({ message: 'Todo not found' });

    todo.title = req.body.title || todo.title;
    todo.completed = req.body.completed != null ? req.body.completed : todo.completed;
    const updatedTodo = await todo.save();
    res.json(updatedTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.deleteTodo = async (req, res) => {
  const id = req.params.id;

  // Validasi ID sebelum melakukan operasi di MongoDB
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


