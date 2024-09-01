const express = require('express');
const connectDB = require('./config/db');
const todoRoutes = require('./routes/todos');
const app = express();
const dotenv = require('dotenv');
const cors = require('cors');

app.use(cors());

dotenv.config();

// Connect to database
connectDB();

// Middleware
app.use(express.json());

// Routes
app.use('/api/todos', todoRoutes);

// Simple route
app.get('/', (req, res) => {
  res.send('Todo API');
});

// Start the server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
