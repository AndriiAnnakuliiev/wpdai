<?php

require_once 'AppController.php';
require_once __DIR__ .'/../models/User.php';
require_once __DIR__.'/../repository/UserRepository.php';

class SecurityController extends AppController {
    public function __construct()
    {
        parent::__construct();
        $this->userRepository = new UserRepository();
    }

    public function admin_page(){

        $pc = $this->userRepository->getUsers();
        $this->render("admin-page");

    }

    public function login()
    {
        $userRepository= new UserRepository();

        if (!$this->isPost()) {
            return $this->render('login');
        }

        $email = $_POST['email'];
        $password = $_POST['password'];
        $user=$userRepository->getUser($email);
        //$user = $this->userRepository->getUser($email);

        if (!$user) {
            return $this->render('login', ['messages' => ['User not found!']]);
        }

        if ($user->getEmail() !== $email) {
            return $this->render('login', ['messages' => ['User with this email not exist!']]);
        }

        if ($user->getPassword() !== $password) {
            return $this->render('login', ['messages' => ['Wrong password!']]);
        }

        session_start();
        $_SESSION['user'] = [
            'email' => $user->getEmail(),
            'name' => $user->getName(),
            'role' => $user->getRole()
        ];

        //$url = "http://$_SERVER[HTTP_HOST]";
        //header("Location: {$url}/");
        $_SESSION['user'] = $user->getEmail();
        header('Location: home');
        exit();
    }
    public function logout(){
        session_start();
        unset($_SESSION['user']);
        unset($_SESSION['admin']);
        session_destroy();
        return $this->render('home', ['messages' => ['You\'ve been successfully logged out!']]);
    }



    public function registration()
    {
        if (!$this->isPost()) {
            return $this->render('registration');
        }

        $email = $_POST['email'] ?? '';
        $password = $_POST['password'] ?? '';
        $name = $_POST['name'] ?? '';
        $role = 'user';
        $user = new User($email, $password, $name,$role);

        $this->userRepository->addUser($user);

        return $this->render('login', ['messages' => ['You\'ve been succesfully registrated!']]);
    }
}