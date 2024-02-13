<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home Page</title>

<link rel = "icon"
 href="public/img/logo.png" 
type = "image/x-icon">

<link rel="stylesheet" type="text/css" 
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">

<link rel="stylesheet" type = "text/css"
href="public/css/home.css">
<script src="https://kit.fontawesome.com/723297a893.js" crossorigin="anonymous"></script>

</head>
<body>
    <?php
        session_start();
    ?>
    <header>
    <div class ="container_menubar">
        <nav>
            <ul>    
                <li><a href="home">Home</a></li>
                <li><a href="about">about</a></li>
                <?php if (isset($_SESSION['user']) || isset($_SESSION['admin'])): ?>
                    <li><a href="/logout" id="logoutButton">Log out</a></li>
                <?php else: ?>
                    <li><a href="/login">Log in</a></li>
                <?php endif; ?>


                <li><a href="pc">PC</a></li>
            </ul>
        </nav>
    </div>
    </header>
  <div class="container_pc">
  <a href="#" class="arrow left-arrow">&lt;</a>

  <div class="PC">
    <img src="public/img/pc-1.jpg" alt="pc-1">
    <a href="login" class="button">Buy</a>
  </div>
  <div class="PC">
    <img src="public/img/pc-2.jpg" alt="pc-2">
    <a href="login" class="button">Buy</a>
  </div>
  <div class="PC">
    <img src="public/img/pc-3.jpg" alt="pc-3">
    <a href="login" class="button">Buy</a>
  </div>
  <div class="PC">
    <img src="public/img/pc-4.jpg" alt="pc-4">
    <a href="login" class="button">Buy</a>
  </div>
  <div class="PC">
    <img src="public/img/pc-5.jpg" alt="pc-5">
    <a href="login" class="button">Buy</a>
  </div>
  <a href="#" class="arrow right-arrow">&gt;</a>
  </div>
  <footer class="footer">
  	 <div class="container-footer">
       <img src = "public/img/logo.png" alt = "logo" class="logo">	
     <div class="row">
  	 		<div class="footer-col">
  	 			<h4>company</h4>
  	 			<ul>
  	 				<li><a href="#">contacts</a></li>
  	 				<li><a href="#">our services</a></li>
  	 				<li><a href="#">privacy policy</a></li>
  	 			</ul>
  	 		</div>
  	 		<div class="footer-col">
  	 			<h4>get help</h4>
  	 			<ul>
  	 				<li><a href="#">FAQ</a></li>
  	 				<li><a href="#">payment options</a></li>
  	 			</ul>
  	 		</div>
               <div class="footer-col">
  	 			<h4>follow us</h4>
  	 			<div class="social-links">
  	 				<a href="#"><i class="fab fa-facebook-f"></i></a>
  	 				<a href="#"><i class="fab fa-twitter"></i></a>
  	 				<a href="#"><i class="fab fa-instagram"></i></a>
  	 				<a href="#"><i class="fab fa-linkedin-in"></i></a>
  	 			</div>
  	 		</div>
               <div class="footer-col">
  	 			<h4>Explore our site</h4>
  	 			<ul>
  	 				<li><a href="#">What's on</a></li>
  	 				<li><a href="#">Coming soon</a></li>
  	 			</ul>
  	 		</div>
  	 	</div>
  	 </div>
  </footer>

</body>
</html>
