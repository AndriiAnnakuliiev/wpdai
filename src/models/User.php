<?php

class User {

    private $email;
    private $password;
    private $name;

    private $role;

    public function __construct(
        string $email,
        string $password,
        string $name='user',
        string $role='user'
    ) {
        $this->email = $email;
        $this->password = $password;
        $this->name = $name;
        $this->role = $role;
    }

    public function getEmail(): string
    {
        return $this->email;
    }
    public function setEmail(string $email)
    {
        $this->email=$email;
    }


    public function getPassword():string
    {
        return $this->password;
    }

    public function setPassword(string $password)
    {
        $this->password=$password;
    }


    public function getName(): string
    {
        return $this->name;
    }

    public function setName(string $name): void
    {
        $this->name = $name;
    }



    public function getRole():string
    {
        return $this->role;
    }

    public function setRole($role): void
    {
        $this->role = $role;
    }
}
