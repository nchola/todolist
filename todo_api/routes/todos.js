const express = require('express');
const router = express.Router();
const todoController = require('../controllers/todoController');

// Define routes
router.get('/', todoController.getAllTodos);
router.post('/', todoController.createTodo);
router.patch('/:id', todoController.updateTodo);
router.delete('/:id', todoController.deleteTodo);
router.get('/category', todoController.getTodosByCategory);

module.exports = router;
