<?php

if (isset($_POST['u_submit'])) {

    require_once("conn.php");

    $var_app_id = $_POST['app_id'];
    $var_score = $_POST['rating'];
   
    $query = "UPDATE basic_info
    SET metacritic= :score
    WHERE  app_id = :app_id";

    $error ="";

    try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':app_id', $var_app_id, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':score', $var_score, PDO::PARAM_INT);

      $result = $prepared_stmt->execute();

    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $query . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}

?>

<html>
  <head>
    <!-- THe following is the stylesheet file. The CSS file decides look and feel -->
    <link rel="stylesheet" type="text/css" href="project.css" />
    <!--//meta tags ends here-->
		 <!--booststrap-->
		 <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" media="all">
		 <!--//booststrap end-->
		 <!-- font-awesome icons -->
		 <link href="css/fontawesome-all.min.css" rel="stylesheet" type="text/css" media="all">
		 <!-- //font-awesome icons -->
		 <!-- For Clients slider -->
		 <link rel="stylesheet" href="css/flexslider.css" type="text/css" media="all" />
		 <!--flexs slider-->
		 <link href="css/JiSlider.css" rel="stylesheet">
		 <!--Shoping cart-->
		 <link rel="stylesheet" href="css/shop.css" type="text/css" />
		 <!--//Shoping cart-->
		 <!--stylesheets-->
		 <link href="css/style.css" rel='stylesheet' type='text/css' media="all">
		 <!--//stylesheets-->
		 <link href="//fonts.googleapis.com/css?family=Sunflower:500,700" rel="stylesheet">
		 <link href="//fonts.googleapis.com/css?family=Open+Sans:400,600,700" rel="stylesheet">
  </head> 

  <body>
  <!--//header-->
  <div class="header-outs" id="home">
			<div class="header-bar">
			   <div class="container-fluid">
				<div class="hedder-up row">
					<div class="col-lg-3 col-md-3 logo-head">
					   <h1><a class="navbar-brand" href="index.html">STEAM App Store</a></h1>
					</div>
					<div class="trashcan">
						<img src="img/trashcan.png" alt="can't display" style="width:30px;height:40px;position:absolute;right:10%">
						<a href="trashcan.php" id="trashcan" style="position:absolute;right:8%;top: 35%;">Trash Can </a>
					</div>
				 </div>
			   </div>
			   <nav class="navbar navbar-expand-lg navbar-light">
				  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				  <span class="navbar-toggler-icon"></span>
				  </button>
				  <div class="collapse navbar-collapse justify-content-center" id="navbarSupportedContent">
				
					<ul>
						<li class="nav-item">
							<a href="index.html" class="nav-link">Home</a>
						</li>
						<li class="nav-item">
							<a href="addVideoGame.php" class="nav-link">Add Video Game</a>
						</li>
						<li class="nav-item">
							<a href="deleteGame.php" class="nav-link">Delete Video Game</a>
						</li>
						<li class="nav-item">
							<a href="updateGame.php" class="nav-link">Update Video Game Rating</a>
						</li>
						
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							Search Video Games
							</a>
							
								<div class="dropdown-content">
								  <a href="getVideoGame byNameorID.php">Search by information</a>
								  <a href="getVideoGame byRestrictions.php">Search by restrictions</a>
								</div>
						 </li>
					 </ul>
				  </div>
			   </nav>
			</div>

    <div class="slider-img one-img">
        <div class="container">
          <div class="slider-info ">
            <h5>Do you have a new rating for a game? <br> Update it here!</h5>
            <form action="updateGame.php" method="post">
              <div>
                <label for="App ID">Enter your video game ID</label>
                <input type="text" name="app_id"> 
              </div>
              <div>
              <label for="Score">Add a new metacritic rating for your game (0-100)</label>
              <input type="text" name="rating"> 
              </div>
        
              <input type="submit" name="u_submit" value="Submit">
            </form>
          </div>
        </div>
      </div>
    
    <?php
      if (isset($_POST['u_submit'])) {
        if ($result) { 
    ?>
          Game app data was inserted successfully.
    <?php 
        } else { 
    ?>
          <h3> Sorry, there was an error. Game app data was not inserted. </h3>
    <?php 
        }
      } 
    ?>

    </body>
  
</html>