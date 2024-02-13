<?php
require 'Routing.php';
$path = trim($_SERVER['REQUEST_URI'], '/');
$path = parse_url( $path, PHP_URL_PATH);
Routing::get('', 'DefaultController');
Routing::get('home', 'DefaultController');
Routing::get('login', 'DefaultController');
Routing::get('registration', 'DefaultController');
Routing::get('about', 'DefaultController');
Routing::get('pc', 'DefaultController');

Routing::post('login', 'SecurityController');
Routing::post('registration', 'SecurityController');



Routing::run($path);