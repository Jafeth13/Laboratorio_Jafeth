require('dotenv').config();
const express = require('express');
const cors = require('cors'); 

const personController = require('./presentation/controllers/PersonController');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/api/persons', personController.getAll);
app.post('/api/persons', personController.create);

app.listen(3000, () => {
    console.log('Node API running on port 3000');
});