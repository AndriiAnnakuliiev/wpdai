<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About us</title>

<link rel = "icon"
 href="public/img/logo.png" 
type = "image/x-icon">

<link rel="stylesheet" type="text/css" 
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">

<link rel="stylesheet" type = "text/css"
  href="public/css/about.css">
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
                <li><a href="#">About</a></li>
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
  <div class="PC">
    <img src="public/img/map.jpg" alt="map">
  </div>
  <div class="company-info">
    <h3>	Working Hours</h3>
    <p>		Mon-Fri: 9:00 - 18:00</p>
    <p>		Sat: 10:00 - 14:00</p>
    <h3>	Address</h3>
    <p>	123 Tech Street, Cyber City, 00000</p>
    <h3>	Phone Number</h3>
    <p>		+1234567890</p>
  </div>
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
