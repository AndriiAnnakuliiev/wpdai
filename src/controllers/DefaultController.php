<?php
require_once 'AppController.php';
class DefaultController extends AppController {
    public function index(){
        $this->render("home");
    }
    public function home(){
        $this->render("home");
    }

    public function login(){
        $this->render("login");
    }

    public function registration(){
        $this->render("registration");

    }

    public function about(){
        $this->render("about");

    }

    public function pc(){
        $this->render("pc");

    }




}