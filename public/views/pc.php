
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home Page</title>
<link rel="icon" href="public/img/logo.png" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="public/css/pc.css">
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
                <li><a href="#">PC</a></li>
            </ul>
        </nav>
    </div>
    </header>

    <main class="container_pc">
        <div class="pc_item">
            <img src="public/img/pc-1.jpg" alt="PC 1">
            <div class="pc_specs">
                <h3>Computer 1</h3>
                <ul>
                    <li>CPU: Intel i5 12400</li>
                    <li>GPU: NVIDIA RTX 3070</li>
                    <li>RAM: 16GB DDR4 3200Mhz</li>
                    <li>PSU: 650W Corsair</li>
                    <li>SSD: 512Gb SATA3</li>
                </ul>
            </div>
        </div>
        <div class="pc_item">
            <img src="public/img/pc-2.jpg" alt="PC 2">
            <div class="pc_specs">
                <h3>Computer 2</h3>
                <ul>
                    <li>CPU: Ryzen 5 5600X</li>
                    <li>GPU: NVIDIA RTX 4070</li>
                    <li>RAM: 16GB DDR4 3800Mhz</li>
                    <li>PSU: 650W Cooler-Master</li>
                    <li>SSD: 1TB NVMe</li>
                </ul>
            </div>
        </div>
        <div class="pc_item">
            <img src="public/img/pc-3.jpg" alt="PC 3">
            <div class="pc_specs">
                <h3>Computer 3</h3>
                <ul>
                    <li>CPU: Ryzen 7 7800X3D</li>
                    <li>GPU: NVIDIA RTX 4080</li>
                    <li>RAM: 32GB DDR4 4000Mhz</li>
                    <li>PSU: 850W ASUS ROG TROR</li>
                    <li>SSD: 2TB NVMe</li>
                </ul>
            </div>
        </div>
        <div class="pc_item">
            <img src="public/img/pc-4.jpg" alt="PC 4">
            <div class="pc_specs">
                <h3>Computer 4</h3>
                <ul>
                    <li>CPU: Ryzen 9 5950X</li>
                    <li>GPU: NVIDIA RTX 4090</li>
                    <li>RAM: 32GB DDR4 4000Mhz</li>
                    <li>PSU: 1000W Corsair</li>
                    <li>SSD: 4TB NVMe</li>
                </ul>
            </div>
        </div>
    </main>

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
