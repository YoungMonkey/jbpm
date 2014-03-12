<%@ page language="java" import="java.util.*,org.jbpm.api.*,org.jbpm.api.task.*;" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String user = (String)session.getAttribute("user");
	if(user == null)
		response.sendRedirect("login.jsp");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
    
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
  	<center>主页</center>
  	当前登陆：【<%=user %>】<a href="login.jsp">重新登录</a><br>
  	<a href="index.jsp?action=deploy">发布新流程</a><br>
  <%
  	ProcessEngine processEngine = Configuration.getProcessEngine();
  	RepositoryService repositoryService = processEngine.getRepositoryService();
  	ExecutionService executionService = processEngine.getExecutionService();
	TaskService taskService = processEngine.getTaskService();
	
	String action = request.getParameter("action");
  	if ("deploy".equals(action)) {
  		repositoryService.createDeployment()
  				.addResourceFromClasspath("process/test.jpdl.xml")
  				.deploy();
  	} else if ("delete".equals(action)) {
  		repositoryService.deleteDeployment(request.getParameter("id"));
  	}
	
	//流程定义
	List<ProcessDefinition> pdList = repositoryService.createProcessDefinitionQuery().list();
	//流程实例
	List<ProcessInstance> piList = executionService.createProcessInstanceQuery().list();
	//我的任务
	List<Task> taskList = taskService.findPersonalTasks(user);

	request.setAttribute("pdList",pdList);

	
  %>
  流程定义
  <table border="1"><tr><td>id</td><td>Name</td><td>Version</td><td>delete</td><td>start</td></tr>
	  <c:forEach items="${pdList}" var="pd">
	  	<tr><td>${pd.id}</td><td>${pd.name }</td><td>${pd.version }</td>
	  	<td><a href="delete.jsp?id=${pd.deploymentId }">delete</a></td>
	  	<td><a href="start.jsp?id=${pd.id }">start</a></td>
	  	</tr>
	  </c:forEach>
  </table><br>
  
   <table border="1" width="40%">
      <caption>流程实例</caption>
     
        <tr>
          <td>id</td>
          <td>activity</td>
          <td>state</td>
          <td>&nbsp;</td>
        </tr>
      
      <tbody>
<%
	for (ProcessInstance pi : piList) {
%>
	    <tr>
	      <td><%=pi.getId() %></td>
	      <td><%=pi.findActiveActivityNames() %></td>
	      <td><%=pi.getState() %></td>
	      <td><a href="view.jsp?id=<%=pi.getId() %>">view</a></td>
	    </tr>
<%
	}
%>
  </tbody>
	</table> 
<br>
  <table border="1" width="40%">
      <caption>待办任务</caption>
      <thead>
        <tr>
          <td>id</td>
          <td>name</td>
          <td>&nbsp;</td>
        </tr>
      </thead>
      <tbody>
<%
	for (Task task : taskList) {
%>
	    <tr>
	      <td><%=task.getId() %></td>
	      <td><%=task.getName() %></td>
	      <td><a href="<%=task.getFormResourceName() %>?id=<%=task.getId() %>">view</a></td>
	    </tr>
<%
	}
%>
	  </tbody>
	</table> 
  </body>
</html>
