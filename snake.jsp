<%@ page import = "java.io.*,java.util.*,java.sql.*"%> 
<%@ page import ="javax.servlet.http.*,javax.servlet.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Snake Game</title>
    <link
      rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="intro.js-2.9.3/intro.js"></script>
    <link href="intro.js-2.9.3/introjs.css" rel="stylesheet" />
    <style>
      html,
      body {
        height: 100%;
        margin: 0;
      }

      body {
        background-image: url("animal-close-up-cobra-106690.jpg");
        background-size: 100% 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background-repeat: no-repeat;
      }
      canvas {
        border: 8px solid white;
        position: relative;
      }
      .custom {
        right: 5%;
        position: absolute;
        opacity: 0.7;
      }
      .navbar {
        opacity: 0.5;
      }
      .custom2 {
        opacity: 0.7;
        position: absolute;
        right: 72%;
        left: 1%;
      }
    </style>
    <%
    String variable = request.getParameter("username");
    %>
    <script>
      $(document).ready(function() {
        introJs().start();
        $("#store").click(function(){
          var score = document.getElementById("maxscore").value;
        console.log(score);
        var username = "<%=variable%>";
        console.log(username);
          $.post("process.jsp",
      {
          score : score,
          username : username
      },
      function(data, status){
          window.location.replace("http://localhost:8080/leaderboard.jsp");
         });
      }
      );
        });
       
    </script>
  </head>
  <body>
    <% String name = request.getParameter("username"); 
    int score = 0;
    String connectionURL = "jdbc:mysql://localhost/snake_game"; 
    Connection connection = null;
    PreparedStatement pstatement = null; 
    int updateQuery = 0;
    Class.forName("com.mysql.jdbc.Driver"); 
    connection = DriverManager.getConnection(connectionURL,"root","goopy"); 
    Statement st=connection.createStatement(); 
    String strQuery = "SELECT COUNT(*) FROM dataset where name='"+name+"'";
    ResultSet rs = st.executeQuery(strQuery);
    rs.next();
    String Countrow = rs.getString(1);
    if(name!=null) { 
      if(name!="" && Countrow.equals("0")) { 
        
              
              String queryString = "insert into dataset(Name,Score) values(?,?)"; 

              pstatement = connection.prepareStatement(queryString); 
              pstatement.setString(1, name);
              pstatement.setInt(2, score);
              updateQuery = pstatement.executeUpdate(); 
            
            
           
            pstatement.close();
            connection.close();
            
            }
            }
    %>
    <nav
      class="navbar navbar-expand-sm bg-light fixed-top"
      data-intro="Leaderboard and Logout buttons for viewing your rank and saving your high score."
    >
      <!-- Links -->
      <ul class="nav navbar-nav m1-auto">
        <li class="nav-item">
          <a class="nav-link" href="leaderboard.jsp">Leaderboard</a>
        </li>
      </ul>
      <ul class="nav navbar-nav ml-auto w-100 justify-content-end">
        <li class="nav-item">
          <a class="nav-link" id="store" href="#" form="myform"
            >Logout</a
          >
        </li>
      </ul>
    </nav>

    <div class="card custom2" data-intro="Read Instructions Carefully.">
      <center><h3>Welcome! <%= request.getParameter("username")%></h3></center>

      <div class="card-body">
        <center><h4 class="card-title">Instructions</h4></center>
        <center>
          <p class="card-text">
            Welcome to the classic game of snake. Before starting let's quickly
            go through the rules and regulation of the game.<br />
          </p>
        </center>
        <br />
        <ol>
          <li>
            Your snake is hungry and needs food. So you need to feed the snake.
          </li>
          <li>Every time you feed the snake it will grow in size.</li>
          <li>Growth in size will increase its crawling speed as well.</li>
          <li>If you touch the boundary, the snake dies.</li>
          <li>Snake even dies if it overlaps itself.</li>
          <li>Pressing Logout will save your High Score.</li>
          <li>You can check your rank at Leaderboard.</li>
        </ol>
        <center><p>Happy Playing!!</p></center>
      </div>
    </div>
    <canvas
      width="600"
      height="600"
      id="game"
      data-intro="Use arrow keys to move the snake."
    ></canvas>
    <div
      class="card custom"
      data-intro="Score board tells your high-score and current score."
    >
      <div class="card-body">
        <div class="text-center"><label for="score" class=>Score</div>
          <form action = "process.jsp" id="myform" method = "POST">
        <input
          type="text"
          value="0"
          class="form-control text-center"
          id="score"
          disabled
        />
        <div class="text-center"><label for="maxscore" class=>Max Score</div>

        <input
          type="text"
          value="0"
          class="form-control text-center"
          id="maxscore"
          disabled
        /></form>
      </div>
    </div>

    <script>
      var canvas = document.getElementById("game");
      var context = canvas.getContext("2d");
      var score = 0;
      var grid = 16;
      var count = 0;
      var maxscore = 0;
      var snake = {
        x: 160,
        y: 160,

        // snake velocity. moves one grid length every frame in either the x or y direction
        dx: grid,
        dy: 0,

        // keep track of all grids the snake body occupies
        cells: [],

        // length of the snake. grows when eating an apple
        maxCells: 4
      };
      var apple = {
        x: 320,
        y: 320
      };
      
      function reset(){
        snake.x = 160;
              snake.y = 160;
              snake.cells = [];
              snake.maxCells = 4;
              snake.dx = grid;
              snake.dy = 0;
              if(maxscore<score){
                maxscore = score;
              }
              score = 0;
              updateScore(score);
              apple.x = getRandomInt(0, 25) * grid;
              apple.y = getRandomInt(0, 25) * grid;
      }
      // get random whole numbers in a specific range
      function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min)) + min;
      }
      function updateScore(score){
        document.getElementById("score").value = score;
        document.getElementById("maxscore").value = maxscore;
      }
      // game loop
      function loop() {
        requestAnimationFrame(loop);

        // slow game loop to 15 fps instead of 60 (60/15 = 4)
        if (++count < 4) {
          return;
        }

        count = 0;
        context.clearRect(0, 0, canvas.width, canvas.height);

        // move snake by it's velocity
        snake.x += snake.dx;
        snake.y += snake.dy;

        // wrap snake position horizontally on edge of screen
        if (snake.x < 0) {
          //snake.x = canvas.width - grid;
          reset();
        } else if (snake.x >= canvas.width) {
          //snake.x = 0;
          reset();
        }

        // wrap snake position vertically on edge of screen
        if (snake.y < 0) {
          // snake.y = canvas.height - grid;
          reset();
        } else if (snake.y >= canvas.height) {
          // snake.y = 0;
          reset();
        }

        // keep track of where snake has been. front of the array is always the head
        snake.cells.unshift({ x: snake.x, y: snake.y });

        // remove cells as we move away from them
        if (snake.cells.length > snake.maxCells) {
          snake.cells.pop();
        }

        // draw apple

        context.fillStyle = "white";
        context.fillRect(apple.x, apple.y, grid - 1, grid - 1);

        // draw snake one cell at a time

        context.fillStyle = "#F5C469";
        snake.cells.forEach(function(cell, index) {
          // drawing 1 px smaller than the grid creates a grid effect in the snake body so you can see how long it is
          context.fillRect(cell.x, cell.y, grid - 1, grid - 1);

          // snake ate apple
          if (cell.x === apple.x && cell.y === apple.y) {
            snake.maxCells++;

            // canvas is 400x400 which is 25x25 grids
            apple.x = getRandomInt(0, 25) * grid;
            apple.y = getRandomInt(0, 25) * grid;
            score++;
            updateScore(score);
          }

          // check collision with all cells after this one (modified bubble sort)
          for (var i = index + 1; i < snake.cells.length; i++) {
            // snake occupies same space as a body part. reset game
            if (cell.x === snake.cells[i].x && cell.y === snake.cells[i].y) {
              reset();
            }
          }
        });
      }

      // listen to keyboard events to move the snake
      document.addEventListener("keydown", function(e) {
        // prevent snake from backtracking on itself

        // left arrow key  | key code of left  button=37
        if (e.which === 37 && snake.dx === 0) {
          snake.dx = -grid;
          snake.dy = 0;
        }
        // up arrow key | key code of up  button=38
        else if (e.which === 38 && snake.dy === 0) {
          snake.dy = -grid;
          snake.dx = 0;
        }
        // right arrow key | key code of right  button=39
        else if (e.which === 39 && snake.dx === 0) {
          snake.dx = grid;
          snake.dy = 0;
        }
        // down arrow key | key code of down  button=40
        else if (e.which === 40 && snake.dy === 0) {
          snake.dy = grid;
          snake.dx = 0;
        }
      });

      // start the game
      requestAnimationFrame(loop);
    </script>
  </body>
</html>
