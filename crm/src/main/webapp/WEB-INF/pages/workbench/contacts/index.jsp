<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=base%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js" ></script>

<script type="text/javascript">
	let isName = false;//名字是否为空
	let isMphone = true;//手机号格式是否正确
	let isEmail = true;//邮箱格式是否正确

	/**
	 * 表单验证方法
	 * @param type
	 */
	function judgeAll(type){
		const fullname = $("#"+type+"-fullname").val();
		const mphone = $("#"+type+"-mphone").val();
		const email = $("#"+type+"-email").val();

		isName = (fullname != "");
		isMphone = (mphone != "") ? /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(mphone) : true;
		isEmail = (email != "") ? /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email) : true;

		$("#"+type+"-btn").prop("disabled",!(isName && isMphone && isEmail))
	}

	/**
	 * 获取所有用户输入的数据
	 * @param type
	 */
	function getAllInput(type){
		return{
			id:$("#"+type+"-id").val(),
			owner:$("#"+type+"-owner").val(),
			source:$("#"+type+"-source").val(),
			fullname:$("#"+type+"-fullname").val(),
			appellation:$("#"+type+"-appellation").val(),
			job:$("#"+type+"-job").val(),
			mphone:$("#"+type+"-mphone").val(),
			email:$("#"+type+"-email").val(),
			customer:$("#"+type+"-customer").val(),
			description:$("#"+type+"-description").val(),
			contactSummary:$("#"+type+"-contactSummary").val(),
			nextContactTime:$("#"+type+"-nextContactTime").val(),
			address:$("#"+type+"-address").val(),
		}
	}

	$(function(){
		queryForPageByCondition(${contactsPageNo == null ? 1 : contactsPageNo},${contactsPageSize == null ? 10 : contactsPageSize})

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//全选 && 反选
		$("#checkAll").click(function (){
			$("#tbody-contacts input[type='checkbox']").prop("checked",$(this).prop("checked"));
		})
		$("#tbody-contacts").on("click","input[type='checkbox']",function (){
			$("#checkAll").prop("checked",($("#tbody-contacts input[type='checkbox']").length == $("#tbody-contacts input[type='checkbox']:checked").length))
		})

		/**
		 * 条件查询按钮
		 */
		$("#search-btn").click(function (){
			queryForPageByCondition(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
		})

		/**
		 * 创建联系人
		 */
		$("#create").click(function (){
			$("#createContactsModal").modal("show");
		})
		//表单验证
		$("#create-fullname,#create-mphone,#create-email").keyup(function (){
			judgeAll("create");
		})
		//提交创建
		$("#create-btn").click(function (){
			const contact = getAllInput("create");

			$.ajax({
				type:'post',
				url:'workbench/contacts/addOneContact.do',
				contentType:'application/json',
				data:JSON.stringify(contact),
				success(data) {
					if (data.code = "1") {
						queryForPageByCondition(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));

						$("#createContactsModal").modal("hide");
						//提交后在执行
						$(".form-horizontal")[0].reset();
						$("#create-btn").prop("disabled",true);
					}else{
						alert(data.message);
					}
				}
			})
		})

		//客户名称自动补全
		$("#create-customer,#edit-customer").typeahead({
			source(jquery,process){
				$.ajax({
					type:'post',
					url:'workbench/contacts/getCustomerListForCreateAndEdit.do',
					data:{
						name:jquery
					},
					success(data){
						process(data.map(item => item.name));
					}
				})
			}
		})

		/**
		 * 修改联系人
		 */
		$("#update").click(function (){

			if ($("#tbody-contacts input[type='checkbox']:checked").length == 1) {
				//加载修改页面数据信息
				$.ajax({
					type:'post',
					url:'workbench/contacts/loadEditPage.do',
					data:{
						id:$("#tbody-contacts input[type='checkbox']:checked").val()
					},
					success(data){
						const contact = data;

						//渲染数据
						$("#edit-id").val(contact.id);
						$("#edit-owner").val(contact.owner);
						$("#edit-source").val(contact.source);
						$("#edit-fullname").val(contact.fullname);
						$("#edit-appellation").val(contact.appellation);
						$("#edit-job").val(contact.job);
						$("#edit-mphone").val(contact.mphone);
						$("#edit-email").val(contact.email);
						$("#edit-customer").val(contact.customer);
						$("#edit-description").val(contact.description);
						$("#edit-contactSummary").val(contact.contactSummary);
						$("#edit-nextContactTime").val(contact.nextContactTime);
						$("#edit-address").val(contact.address);

						$("#editContactsModal").modal("show");
					}
				})
			}else {
				alert("请选择一个联系人进行信息修改...");
			}
		})
		//表单验证
		$("#edit-owner").blur(function (){
			judgeAll("edit");
		})
		$(".form-horizontal:eq(1) input,.form-horizontal:eq(1) textarea").keyup(function (){
			judgeAll("edit");
		})
		//点击更新按钮
		$("#edit-btn").click(function (){
			const contact = getAllInput("edit");//获取联系人对象

			$.ajax({
				type:'post',
				url:'workbench/contacts/saveEditContact.do',
				contentType: 'application/json',
				data:JSON.stringify(contact),
				success(data){
					if (+data.code) {
						queryForPageByCondition(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
						$("#editContactsModal").modal("hide");
						//提交后再执行
						$(".form-horizontal")[1].reset();
						$("#edit-btn").prop("disabled",true);
					}else {
						alert(data.message);
					}
				}
			})
		})

		/**
		 * 删除联系人
		 */
		$("#remove").click(function (){
			if (confirm("你确认删除吗？")) {
				let ids = [];
				$("#tbody-contacts input[type='checkbox']:checked").each(function (){
					ids.push($(this).val())
				})

				$.ajax({
					type:'post',
					url:'workbench/contacts/deleteContacts.do',
					traditional: true,
					data:{
						ids:ids
					},
					success(data){
						if (+data.code) {
							queryForPageByCondition(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
						}else {
							alert(data.message);
						}
					}
				})
			}
		})

		//日历组件
		$("#create-nextContactTime,#edit-nextContactTime").datetimepicker({
			format:"yyyy-mm-dd",//日期格式
			language:"zh-CN",//语言
			minView:'month',
			initialDate:new Date(),//初始化时显示当前日期
			autoclose:true,//设置选择完日期或时间之后，是否自动关闭日历
			clearBtn:true,//设置是否显示清空按钮，默认为false
			todayBtn:true//设置是否显示今日按钮
		});
	});

	/**
	 * 渲染联系人列表
	 * @param pageNo
	 * @param pageSize
	 */
	function queryForPageByCondition(pageNo,pageSize){
		//获取用户模糊查询表单输入
		const owner = $("#search-owner").val();
		const fullname = $("#search-fullname").val();
		const customer = $("#search-customer").val();
		const source = $("#search-source").val();

		$("#checkAll").prop("checked",false);

		//发送ajax请求
		$.ajax({
			type:'post',
			url:'workbench/contacts/queryForPageByCondition.do',
			data:{
				owner:owner,
				fullname:fullname,
				customer:customer,
				source:source,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success(data){
				if (data != null) {
					const contacts = data.contacts;//获取联系人集合
					const totalRows = data.totalRows;//获取总条数

					console.log(totalRows);
					console.log(contacts.length == 0 && totalRows != 0)

					if (contacts.length == 0 && pageNo != 1) {
						queryForPageByCondition(pageNo - 1,pageSize);
					}else {
						//渲染联系人列表
						let html = "";

						contacts.forEach(contact => {
							html += "<tr>";
							html += "	<td><input value='"+contact.id+"' type=\"checkbox\" /></td>";
							html += "	<td><a style=\"text-decoration: none; cursor: pointer;\">"+contact.fullname+"</a></td>";
							html += "	<td>"+contact.customer+"</td>";
							html += "	<td>"+contact.owner+"</td>";
							html += "	<td>"+contact.source+"</td>";
							html += "</tr>";
						})

						$("#tbody-contacts").html(html);

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
								queryForPageByCondition(currentPage,rowsPerPage);//刷新页面
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

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<%--modal-body--%>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<%--create-owner create-source--%>
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<%--create-owner--%>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}" >${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<%--create-source--%>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								<c:forEach items="${sources}" var="source">
									<option value="${source.id}">${source.value}</option>
								</c:forEach>
								</select>
							</div>
						</div>
						<%--create-fullname create-call--%>
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellations}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						<%--create-job create-mphone--%>
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						<%--create-email create-customer--%>
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-customer" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customer">
							</div>
						</div>

						<%--create-description--%>
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						<%--create-contactSummary create-nextContactTime--%>
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						<%--create-address--%>
                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="create-btn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<%--edit-id--%>
						<input id="edit-id" type="hidden">
						<%--edit-owner edit-source--%>
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}" >${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sources}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<%--edit-fullname edit-appellation--%>
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellations}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<%--edit-job edit-mphone--%>
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						<%--edit-email edit-customer--%>
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-customer" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customer" value="动力节点">
							</div>
						</div>
						<%--edit-description--%>
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						<%--edit-contactSummary edit-nextContactTime--%>
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						<%--edit-address--%>
                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="edit-btn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<%--标题--%>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>

	<%--主体部分--%>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<%--搜索栏--%>
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <%--search-owner--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-fullname--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input id="search-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-customer--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="search-customer" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  <%--search-source--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="search-source" class="form-control" id="edit-clueSource">
						  <option></option>
						  <c:forEach items="${sources}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>

				  <%--search-btn--%>
				  <button id="search-btn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<%--工具栏--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="create" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="update" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="remove" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>
			<%--渲染列表--%>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
						</tr>
					</thead>
					<tbody id="tbody-contacts">
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                        </tr>
					</tbody>
				</table>
			</div>

			<%--分页组件--%>
			<div id="bs-pagination">

			</div>
			
		</div>
		
	</div>
</body>
</html>