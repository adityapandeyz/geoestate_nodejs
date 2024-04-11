// IMPORTS FROM PACKAGES
const express = require("express");
const { Client } = require("pg");
const url = require('url');

// IMPORT FROM OTHER FILES
const authRouter = require("./routes/auth");
const markerRouter = require("./routes/marker");
const datasetRouter = require("./routes/dataset");
const bankRouter = require("./routes/bank");

// INIT
const PORT = 3000;
const app = express();

// Middleware for parsing JSON bodies
app.use(express.json());


// Connection configuration
const cockroachDBUrl = 'postgresql://geoestate_cloud:iPCbsK-7VzPQws2HwprBFw@geoestate-8844.8nk.gcp-asia-southeast1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full';

// Parse the CockroachDB URL
const params = url.parse(cockroachDBUrl);
const auth = params.auth.split(':');

const client = new Client({
  user: auth[0],
  password: auth[1],
  host: params.hostname,
  database: params.pathname.split('/')[1],
  port: params.port,
  ssl: {
    rejectUnauthorized: true // Enable SSL mode
    // Add your SSL certificate here if necessary
    // ca: '-----BEGIN CERTIFICATE-----\n...'
  },
});

// Connect to CockroachDB
client.connect()
  .then(() => console.log('Connected to CockroachDB'))
  .catch(err => {
    console.error('Connection error', err.stack);
    process.exit(1); // Exit the process if connection fails
  });

// Mount the authRouter after setting up middleware
app.use(authRouter);
app.use(markerRouter);
app.use(datasetRouter);
app.use(bankRouter);

// Start the server
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is running on port ${PORT}`);
});
