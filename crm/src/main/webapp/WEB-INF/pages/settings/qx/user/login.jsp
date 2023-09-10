<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme()+"://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%= basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form class="form-horizontal" role="form" >
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" value="${cookie.loginAct.value}">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" value="${cookie.loginPwd.value}">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct}">
								<input id="checkbox" type="checkbox" checked> 十天内免登录
							</c:if>
							<c:if test="${empty cookie.loginAct}" >
								<input id="checkbox" type="checkbox"> 十天内免登录
							</c:if>
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<button type="button" id="login" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
	<script type="text/javascript" >
		document.addEventListener("DOMContentLoaded",function (){
			$("#login").text("登陆");//刷新登录状态

			const requestLogin = null;

			//实现通过回车键登录
			$(document).keydown(function (ev){
				if (ev.keyCode === 13) {
					//在指定的标签模拟发送单击事件
					$('button').click();//调用button的click事件
				}
			})

			$("button").click(function (event){
				//获取用户名
				const loginAct = $.trim($(".form-control").eq(0).val());
				const loginPwd = $.trim($(".form-control").eq(1).val());
				const isRemPwd = $("#checkbox").prop("checked");

				if (""===loginAct || ""===loginPwd){
					alert("用户名或密码不能为空!");
					return;
				}

				//修改登录按钮文字体现登录状态
				$("#login").text("登陆中...");

				$.ajax({
					url:"settings/qx/user/login.do",
					type:"post",
					data:{
						loginAct,loginAct,
						loginPwd,loginPwd,
						isRemPwd,isRemPwd
					},
					success(result){
						const code = result.code;

						if (+code) {
							$("#login").text("已登陆");//修改登录按钮文字体现登录成功
							//可以跳转
							window.location.href="workbench/index.do";
						}else {
							$("#login").text("登录失败");//修改登录按钮文字体现登录成功
							//跳出警告
							$("#msg").text(result.message);
							return;
						}
					},
					beforeSend:function (){
						/*该函数内部可以验证请求携带的参数
						如果返回true才会通过ajax向后端发送请求
						返回false ajax不会做任何行为*/
					}
				})
			})
		})
	</script>
</body>
</html>