const mysql = require("mysql2");
const config = require("app_config");

const dbase = mysql.createPool({
	"connectionLimit": config["dbconnectionLimit"],
	"host": config["dbhost"],
	"database": config["dbdatabase"],
	"user": config["dbuser"],
	"password": config["dbpassword"]
}).promise();

// let [rows, fields] = await dbase.execute(sql, params);

module.exports = dbase;