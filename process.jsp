<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<html>
   <head>
      <title>Storing Data</title>
   </head>
   
   <body>
      <%
      int score=Integer.parseInt(request.getParameter("score"));
      String name =request.getParameter("username");
      %>
      <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
      url = "jdbc:mysql://localhost/snake_game"
      user = "root" password = "goopy"/>
      <sql:update dataSource = "${snapshot}" var = "count">
         UPDATE dataset SET Score = <%=score%> WHERE Name = "<%=name%>" AND Score < <%=score%>;
      </sql:update>
     <sql:query dataSource = "${snapshot}" var = "result">
        SELECT * from dataset;
     </sql:query>
    <table border = "1" width = "100%">
       <tr>
          <th>Name</th>
          <th>Score</th>
          
       </tr>
       <c:forEach var = "row" items = "${result.rows}">
          <tr>
             <td> <c:out value = "${row.Name}"/></td>
             <td> <c:out value = "${row.Score}"/></td>
             
          </tr>
       </c:forEach>
    </table>
   </body>
</html>