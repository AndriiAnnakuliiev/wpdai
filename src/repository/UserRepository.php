<?php

require_once 'Repository.php';
require_once __DIR__.'/../models/User.php';

class UserRepository extends Repository
{

    public function getUser(string $email): ?User
    {
        $stmt = $this->database->connect()->prepare('
            SELECT * FROM public.users WHERE email = :email');
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();

        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user == false) {
            return null;
        }

        return new User(

            $user['email'],
            $user['password'],
            $user['name'] ??'user',
            $user['role']??'user'
        );
    }

    public function addUser(User $user)
    {
        $stmt = $this->database->connect()->prepare("
    INSERT INTO public.users (name,password,email,role)  VALUES (?,?,?,?)");

        $stmt->execute([
            $user->getName(),
            $user->getPassword(),
            $user->getEmail(),
            $user->getRole()
        ]);

    }


    public function getUsers(): array
    {
        $result = [];

        $stmt = $this->database->connect()->prepare('
            SELECT * FROM public.users;
        ');
        $stmt->execute();
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($users as $user) {
            $result[] = new User(
                $user['email'],
                $user['password'],
                $user['name'],
                $user['role']
            );
        }
        return $result;
    }


}