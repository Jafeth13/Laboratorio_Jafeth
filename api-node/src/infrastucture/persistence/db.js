const sql = require('mssql');

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_HOST,
    database: process.env.DB_NAME,
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};

let pool;

async function connectWithRetry() {
    let retries = 5;

    while (retries > 0) {
        try {
            pool = await new sql.ConnectionPool(config).connect();
            console.log("Connected to SQL Server");
            return pool;
        } catch (err) {
            console.log(` DB not ready... retries left: ${retries}`);
            retries--;
            await new Promise(res => setTimeout(res, 5000));
        }
    }

    throw new Error("❌ Could not connect to SQL Server");
}

module.exports = { connectWithRetry };