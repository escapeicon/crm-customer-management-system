<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
<base href="<%= base%>" />
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	/**
	 * 入口函数
	 */
	$(function(){
		queryForPage(${transactionPageNo == null ? 1 : transactionPageNo},${transactionPageSize == null ? 10 : transactionPageSize});

		//模糊查询
		$("#search-btn").click(function (){
			queryForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
		})

		//全选 && 反选
		$("#checkAll").click(function (){
			$("#tbody-transaction input[type='checkbox']").prop("checked",$("#checkAll").prop("checked"));
		})
		$("#tbody-transaction").on("click","input[type='checkbox']",function (){
			$("#checkAll").prop("checked",$("#tbody-transaction input[type='checkbox']:checked").length == $("#tbody-transaction input[type='checkbox']").length);
		})

		/**
		 * 跳转修改交易页面
		 */
		$("#update").click(function (){
			const transactionChecked = $("#tbody-transaction input[type='checkbox']:checked");
			if (transactionChecked.length == 1) {
				const transactionId = transactionChecked.val();
				window.location.href = "workbench/transaction/toEditTransaction.do?transactionId="+transactionId;
			}else {
				alert("请选择一条交易进行修改...");
			}
		})

		/**
		 * 删除交易
		 */
		$("#delete").click(function (){
			if (confirm("你确认删除该条记录吗？")) {
				const transactionChecked = $("#tbody-transaction input[type='checkbox']:checked");

				if (transactionChecked.length > 0) {

					let ids = [];
					transactionChecked.each(function (){
						ids.push($(this).val())
					})

					$.ajax({
						tyep:'post',
						url:'workbench/transaction/deleteTransaction.do',
						traditional:true,
						data:{
							ids:ids
						},
						success(data) {
							if (+data.code) {
								queryForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
							}else {
								alert(data.message);
							}
						}
					})
				}else {
					alert("请至少选择一条交易进行删除...");
				}
			}
		})

		/**
		 * 跳转至交易详情页
		 */
		$("#tbody-transaction").on("click","a",function (){
			const transactionId = $(this).attr("transactionId");
			window.location.href = 'workbench/transaction/toTransactionDetail.do?transactionId='+transactionId;
		})
	});

	/**
	 * 渲染交易 方法
	 * @param pageNo
	 * @param pageSize
	 */
	function queryForPage(pageNo,pageSize){
		//获取用户输入的参数
		const owner = $("#search-owner").val();
		const name = $("#search-name").val();
		const customerId = $("#search-customerId").val();
		const stage = $("#search-stage").val();
		const type = $("#search-type").val();
		const source = $("#search-source").val();
		const contactsId = $("#search-contactsId").val();

		$("#checkAll").prop("checked",false);

		//发送ajax请求
		$.ajax({
			type:'post',
			url:'workbench/transaction/queryForPageByCondition.do',
			data:{
				owner:owner,
				name:name,
				customerId:customerId,
				stage:stage,
				type:type,
				source:source,
				contactsId:contactsId,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success(data){
				if (data != null) {
					const transactions = data.transactions;
					const totalRows = data.totalRows;

					if (transactions.length == 0 && pageNo != 1) {
						queryForPage(pageNo - 1,pageSize);
					}else {
						//渲染交易列表
						let html = "";

						transactions.forEach(transaction => {
							html += "<tr>";
							html += "	<td><input value='"+transaction.id+"' type=\"checkbox\" /></td>";
							html += "	<td><a transactionId='"+transaction.id+"' style=\"text-decoration: none; cursor: pointer;\">"+transaction.name+"</a></td>";
							html += "	<td>"+transaction.customerId+"</td>";
							html += "	<td>"+transaction.stage+"</td>";
							html += "	<td>"+(transaction.type == null ? '&nbsp;' : transaction.type)+"</td>";
							html += "	<td>"+transaction.owner+"</td>";
							html += "	<td>"+(transaction.source == null ? "" : transaction.source)+"</td>";
							html += "	<td>"+(transaction.contactsId == null ? "" : transaction.contactsId)+"</td>";
							html += "</tr>";
						})

						$("#tbody-transaction").html(html);

						$("#bs-pagination").bs_pagination({
							currentPage:pageNo,//页码
							rowsPerPage:pageSize,//每页显示条数
							totalRows:totalRows,//总条数
							totalPages:totalRows % pageSize == 0 ? totalRows / pageSize : parseInt(totalRows / pageSize + 1),//总页面
							showGoToPage:true,
							showRowsPerPage:true,
							showRowsInfo:true,
							visiblePageLinks:10,
							onChangePage:function (event,data){
								const currentPage = data.currentPage;//获取当前页面
								const rowsPerPage = data.rowsPerPage;//获取每页显示条数
								queryForPage(currentPage,rowsPerPage);//刷新页面
							}
						})
					}
				}
			}
		})
	}
</script>
</head>
<body>

	<%--标题--%>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>


	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<%--搜索栏--%>
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <%--search-owner--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-name--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-customerId--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="search-customerId" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  <%--search-stage--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="search-stage" class="form-control">
					  	<option></option>
						<c:forEach items="${stages}" var="stage">
							<option value="${stage.id}">${stage.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  <%--search-type--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="search-type" class="form-control">
					  	<option></option>
						<c:forEach items="${types}" var="type">
							<option value="${type.id}">${type.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <%--search-source--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="search-source" class="form-control">
						  <option></option>
							<c:forEach items="${sources}" var="source">
								<option value="${source.id}">${source.value}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  <%--search-contactsId--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="search-contactsId" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="search-btn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>

			<%--工具栏--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/toTransactionSavePage.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="update" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="delete" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<%--transaction列表--%>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<%--tbody-transaction--%>
					<tbody id="tbody-transaction">
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>
					</tbody>
				</table>
			</div>

			<%--分页组件--%>
			<div style="height: 50px; position: relative;top: 20px;" id="bs-pagination">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>