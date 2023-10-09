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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	let isOwnerAndName = false;//所有者 和 名称 是否填写
	let isWebsite = true;//网站 是否正确
	let isPhone = true;//电话 是否正确

	/**
	 * 渲染客户列表
	 * @param pageNo
	 * @param pageSize
	 */
	function renderCustomerList(pageNo,pageSize){
		//获取用户查询栏的输入
		let name = $("#search-name").val();
		let owner = $("#search-owner").val();
		let phone = $("#search-phone").val();
		let website = $("#search-website").val();

		$.ajax({
			type:'post',
			url:"workbench/customer/queryForPageByCondition.do",
			data:{
				name:name,
				owner:owner,
				phone:phone,
				website:website,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success(data){
				if (data != null) {
					const customers = data.customers;
					let totalRows = data.totalRows;

					if (customers.length == 0 && totalRows != 0) {
						renderCustomerList(pageNo - 1,pageSize);
					}else {

						//渲染 customers列表
						let html = "";

						customers.forEach(customer => {
							html += "<tr>";
							html += "	<td><input type=\"checkbox\" value='"+customer.id+"'/></td>";
							html += "	<td><a style=\"text-decoration: none; cursor: pointer;\" >"+customer.name+"</a></td>";
							html += "	<td>"+customer.owner+"</td>";
							html += "	<td>"+(customer.phone == null ? "" : customer.phone)+"</td>";
							html += "	<td>"+(customer.website == null ? "" : customer.website)+"</td>";
							html += "</tr>";
						})

						$("#tbody-customer").html(html);

						//分页组件
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
								renderCustomerList(currentPage,rowsPerPage);//刷新页面
							}
						})
					}
				}
			}
		})
	}

	/**
	 * 创建 更新 表单验证
	 */
	function judgeAll(type){

		//获取名称 输入内容
		const name = $("#"+type+"-name").val();
		//获取网址 电话输入内容
		const website = $("#"+type+"-website").val();
		const phone = $("#"+type+"-phone").val();

		//验证名称
		isOwnerAndName = (name != "");
		//验证网站
		isWebsite = (website != "" ? /^http([s]?):\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/.test(website) : true);
		//验证公司座机
		isPhone = (phone != "" ? /^(\d{3,4}-)?\d{7,8}$/.test(phone) : true);

		//是否解禁提交按钮
		$("#"+type+"-btn").prop("disabled",!(isOwnerAndName && isWebsite && isPhone));
	}

	/**
	 * 获取用户输入的表单数据
	 * @param type
	 * @returns {{owner: (*|jQuery), nextContactTime: (*|jQuery), website: (*|jQuery), address: (*|jQuery), phone: (*|jQuery), name: (*|jQuery), description: (*|jQuery), contactSummary: (*|jQuery)}}
	 */
	function getAllInput(type){
		return{
			owner:$("#"+type+"-owner").val(),
			name:$("#"+type+"-name").val(),
			website:$("#"+type+"-website").val(),
			phone:$("#"+type+"-phone").val(),
			description:$("#"+type+"-description").val(),
			contactSummary:$("#"+type+"-contactSummary").val(),
			nextContactTime:$("#"+type+"-nextContactTime").val(),
			address:$("#"+type+"-address").val(),
		}
	}

	$(function(){
		renderCustomerList(${customerPageNo == null ? 1 : customerPageNo},${customerPageSize == null ? 10 : customerPageSize});
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//实现全选
		$("#all-checkbox").click(function (){
			$("#tbody-customer input[type='checkbox']").prop("checked",$("#all-checkbox").prop("checked"));
		})
		//实现反选
		$("#tbody-customer").on("click","input[type='checkbox']",function (){
			$("#all-checkbox").prop("checked",$("#tbody-customer input[type='checkbox']").length == $("#tbody-customer input[type='checkbox']:checked").length);
		})

		/**
		 * 条件查询
		 */
		$("#search-btn").click(function (){
			renderCustomerList(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
		})

		/**
		 * 创建客户
		 */
		$("#create-btn").click(function (){
			const customer = getAllInput("create");

			$.ajax({
				type:'post',
				url:'workbench/customer/saveCustomer.do',
				data:customer,
				success(data) {
					if (data.code) {
						renderCustomerList(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));//刷新网页
						$("#createCustomerModal").modal("hide");//隐藏创建客户模态窗口

						//留在表单更新完成后执行
						$(".form-horizontal")[0].reset();
						$("#create-btn").prop("disabled",true);
					}else {
						alert(data.message);
					}
				}
			})
		})
		//创建表单验证
		$("#create-name,#create-website,#create-phone").keyup(function (){
			judgeAll("create");
		})

		/**
		 * 更新
		 */
		//弹出更新模态窗口
		$("#update").click(function (){
			const checkedCustomer = $("#tbody-customer input[type='checkbox']:checked");
			if (checkedCustomer.length == 1) {
				const customerId = checkedCustomer.val();//获取客户id

				$.ajax({
					type:'post',
					url:'workbench/customer/loadCustomer.do',
					data:{
						id:customerId
					},
					success(data){
						if (data.code) {
							const customer = data.data;

							$("#customer-id").val(customer.id);
							$("#edit-owner").val(customer.owner);
							$("#edit-name").val(customer.name);
							$("#edit-website").val(customer.website);
							$("#edit-phone").val(customer.phone);
							$("#edit-description").val(customer.description);
							$("#edit-contactSummary").val(customer.contactSummary);
							$("#edit-nextContactTime").val(customer.nextContactTime);
							$("#edit-address").val(customer.address);

							$("#editCustomerModal").modal("show");//显示模态窗口
						}else{
							alert(data.message)
						}
					}
				})
			}else {
				alert("请选择一位客户进行修改!");
			}
		})
		//更新按钮
		$("#edit-btn").click(function (){
			const customer = getAllInput("edit");//获取用户已修改的客户对象
			customer.id = $("#customer-id").val();

			$.ajax({
				type:'post',
				url:'workbench/customer/saveEditedCustomer.do',
				data:customer,
				success(data){
					if (data.code) {
						$("#editCustomerModal").modal("hide");//关闭模态窗口
						renderCustomerList(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));

						//留在表单更新完成后执行
						$(".form-horizontal")[1].reset();
                        $("#edit-btn").prop("disabled",true);
					}else {
						alert(data.message);
					}
				}
			})
		})
		//更新表单验证
		$("#edit-owner").change(function (){
			judgeAll("edit");
		})
		$(".form-horizontal:eq(1) input,.form-horizontal:eq(1) textarea").keyup(function (){
			judgeAll("edit");
		})

		/**
		 * 删除 客户
		 */
		$("#delete").click(function (){
			const customer_checkbox = $("#tbody-customer input[type='checkbox']:checked");

			if (customer_checkbox.length > 0) {
				if (confirm("你确定要删除这些用户吗?")) {
					let ids = [];

					customer_checkbox.each(function (){
						ids.push($(this).val())
					})

					$.ajax({
						type:'post',
						url:'workbench/customer/deleteCustomer.do',
						traditional:true,
						data:{
							ids:ids
						},
						success(data){
							if (data.code) {
								renderCustomerList(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
							}else {
								alert(data.message);
							}
						}
					})
				}
			}else {
				alert("请至少选择一个客户进行删除...")
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
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<%--create-owner create-name--%>
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<%--create-customerName--%>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>

						<%--create-website create-phone--%>
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<%--create-description--%>
						<div class="form-group">
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
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="create-btn" type="button" class="btn btn-primary" disabled>保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<%--customer-id--%>
						<input id="customer-id" type="hidden">
						<%--edit-owner edit-name--%>
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								<c:forEach items="${users}" var="user">
									<option value="${user.id}">${user.name}</option>
								</c:forEach>
								</select>
							</div>
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="动力节点">
							</div>
						</div>

						<%--edit-website edit-phone--%>
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						<%--edit-description--%>
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
                                    <input type="text" class="form-control" id="edit-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<%--edit-address--%>
                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="edit-btn" type="button" class="btn btn-primary" disabled>更新</button>
				</div>
			</div>
		</div>
	</div>

	<%--标题--%>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<%--搜索栏--%>
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <%--search-name--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-owner--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-phone--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="search-phone" class="form-control" type="text">
				    </div>
				  </div>
				  <%--search-website--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input id="search-website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="search-btn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<%--工具栏--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="update" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="delete" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>

			<%--渲染列表--%>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="all-checkbox" type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tbody-customer">

					</tbody>
				</table>
			</div>

			<%--分页查询栏--%>
			<div id="bs-pagination">

			</div>
			
		</div>
		
	</div>
</body>
</html>