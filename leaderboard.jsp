<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Leaderboard</title>
</head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script> 
<style>
    body{
        background-image: url('ancient-antique-architecture-615344.jpg');
        background-size: 100%;
        background-repeat: no-repeat;
    }
    .table{
        opacity: 0.7;
    }
</style>
<body>
        <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
        url = "jdbc:mysql://localhost/snake_game"
        user = "root"  password = "goopy"/>

     <sql:query dataSource = "${snapshot}" var = "result">
        SELECT * from dataset order by Score desc;
     </sql:query>
     <div class="container">
         <p class="display-1 text-center"><u>Leaderboard</u></p>
            <table class = "table table-bordered table-hover table-dark text-center" border = "1" width = "100%">
                    <tr class="text-center">
                       <th>Username</th>
                       <th>Score</th>
                    </tr>
                    
                    <c:forEach var = "row" items = "${result.rows}">
                       <tr>
                          <td><c:out value = "${row.Name}"/></td>
                          <td><c:out value = "${row.Score}"/></td>
                       </tr>
                    </c:forEach>
                 </table>
     </div>
     <center><p class="display-4"><a href="index.html" style="color:black;">Go Back</a></p></center>
</body>
</html>