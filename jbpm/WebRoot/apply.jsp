<%@ page language="java" import="java.util.*,org.jbpm.api.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

if(request.getParameter("apply") != null){
	int day = Integer.parseInt((String)request.getParameter("day"));
	String reason = request.getParameter("reason");
	
	Map map = new HashMap();
	//map.put("owner",session.getAttribute("user"));
	map.put("day",day);
	map.put("reason",reason);
	
	ProcessEngine processEngine = Configuration.getProcessEngine();
 	TaskService taskService = processEngine.getTaskService();
 	
 	taskService.completeTask(request.getParameter("id"),map);
 	response.sendRedirect("index.jsp");
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'apply.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  <form action="apply.jsp" method="post">
  <input type="hidden" name="id" value="${param.id }"/>
    请假天数：<input type="text" name="day"><br>
  请假原因：<textarea name="reason"></textarea><br/>
  <input type="submit" name="apply" value="提交">
  </form>
  </body>
</html>
