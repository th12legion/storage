var express = require('express'),
	  router = express.Router();

// Модули для парсинга входящих данных	  
var bodyParser = require('body-parser');
var multer = require('multer');

// Парсим входящие данные
router.use(bodyParser.json()); // support json encoded bodies
router.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies
router.use(multer().array()); 

// Основной мидлвейр для простановки базовых опций
router.use(function(req, res, next) {
	res.set('Content-Type', 'application/json');
	
	if (req.method=="OPTIONS"){
		res.set('Access-Control-Allow-Origin', req.headers.origin);
		res.set('Access-Control-Allow-Credentials', true);
		res.set('Access-Control-Max-Age', 600);
		res.set('Access-Control-Allow-Headers', "authorization,package");
		res.end(null);
		return false;
	}else{
		res.setHeader('Access-Control-Allow-Origin', "*");
	}
	
	next();
});

var model = require("./comp.model.js");

// Слушатель на домашнюю страницу
router.get('/', function(req, res){
	res.send('{"status":1,"page":"home", "body": null}');
});

// Слушатель на страницу статус
router.get('/status', async function(req, res){
	res.json({
		"status":1,
		"page":"status",
		"body": await model()
	});
});

module.exports = router;