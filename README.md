
---

# **Step 1: Initialize the Node.js Project**

1. Install [Node.js](https://nodejs.org/) if you haven’t already.
2. Create a new project folder and initialize it:
   ```sh
   mkdir nodejs-crud-swagger
   cd nodejs-crud-swagger
   npm init -y
   ```

---

# **Step 2: Install Dependencies**

Run the following command to install necessary dependencies:

```sh
npm install express body-parser swagger-jsdoc swagger-ui-express
```

- `express`: Web framework for Node.js.
- `body-parser`: Middleware to handle JSON requests.
- `swagger-jsdoc`: Generates Swagger documentation.
- `swagger-ui-express`: Serves Swagger UI.

---

# **Step 3: Create the `index.js` File**

Now, create a file named `index.js` and add the following CRUD API with Swagger documentation:

```javascript
const express = require("express");
const bodyParser = require("body-parser");
const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");

const app = express();
const port = 3000;

app.use(bodyParser.json());

const swaggerOptions = {
  swaggerDefinition: {
    openapi: "3.0.0",
    info: {
      title: "CRUD API",
      version: "1.0.0",
      description: "A simple CRUD API with Swagger documentation",
    },
  },
  apis: ["./index.js"],
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));

const items = [];

/**
 * @swagger
 * /items:
 *   get:
 *     summary: Get all items
 *     responses:
 *       200:
 *         description: Success
 */
app.get("/items", (req, res) => {
  res.json(items);
});

/**
 * @swagger
 * /items:
 *   post:
 *     summary: Create an item
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *     responses:
 *       201:
 *         description: Created
 */
app.post("/items", (req, res) => {
  const { name } = req.body;
  const newItem = { id: items.length + 1, name };
  items.push(newItem);
  res.status(201).json(newItem);
});

/**
 * @swagger
 * /items/{id}:
 *   put:
 *     summary: Update an item
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *     responses:
 *       200:
 *         description: Updated
 */
app.put("/items/:id", (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  const item = items.find((item) => item.id === parseInt(id));
  if (item) {
    item.name = name;
    res.json(item);
  } else {
    res.status(404).json({ message: "Item not found" });
  }
});

/**
 * @swagger
 * /items/{id}:
 *   delete:
 *     summary: Delete an item
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Deleted
 */
app.delete("/items/:id", (req, res) => {
  const { id } = req.params;
  const index = items.findIndex((item) => item.id === parseInt(id));
  if (index !== -1) {
    items.splice(index, 1);
    res.json({ message: "Item deleted" });
  } else {
    res.status(404).json({ message: "Item not found" });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
```

---

# **Step 4: Run the Application**

Start the server using:

```sh
node index.js
```

Your API will be available at `http://localhost:3000`.

To access Swagger documentation, open:

```
http://localhost:3000/api-docs
```

---

# **Step 5: Create a `Dockerfile` with Multi-Stage Build**

Create a file named `Dockerfile`:

```Dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .

# Stage 2: Run
FROM node:18
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 3000
CMD ["node", "index.js"]
```

---

# **Step 6: Build and Run with Docker**

Build the Docker image:

```sh
docker build -t nodejs-crud-app .
```

Run the container:

```sh
docker run -p 3000:3000 nodejs-crud-app
```

Now, visit `http://localhost:3000/api-docs` to see the Swagger UI.

---

# **Conclusion**
You have successfully created a CRUD API with Node.js, Express, and Swagger, and containerized it using a multi-stage Docker build.

Would you like to add a database like MongoDB or PostgreSQL next? 🚀