<%@ page language="java" import="java.util.*,org.jbpm.api.*" pageEncoding="UTF-8"%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>My JSP 'manager.jsp' starting page</title>
  </head>
  
  <body>
  <%
request.setCharacterEncoding("utf-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	ProcessEngine processEngine = Configuration.getProcessEngine();
 	TaskService taskService = processEngine.getTaskService();
 	String id = request.getParameter("id");

	String result = request.getParameter("result");
	if(result != null){
 		taskService.completeTask(id,result);
		response.sendRedirect("index.jsp");
	}else{

%>
     姓名：<%=taskService.getVariable(id,"owner") %><br>
     天数：<%=taskService.getVariable(id,"day") %><br>
     原因：<%=taskService.getVariable(id,"reason") %><br>
     <%} %>
 <form action="manager.jsp" method="post">
 	<input type="hidden" name="id" value="${param.id }">
	<input name="result" type="submit" value="批准">  
	<input name="result" type="submit" value="驳回">  
 </form>
     
  </body>
</html>
