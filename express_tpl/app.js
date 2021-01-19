var app_config = require('app_config');
app_config.root_dir = __dirname;

var express = require('express');
var app = express();

//------------ Сексция с компонентами ------------
var main = require('./components/main');
var page_404 = require('./components/page_404');

app.use(express.static(__dirname + '/public'));

app.use(main);

app.use(page_404);
//------------ Сексция с компонентами ------------

module.exports = app;
