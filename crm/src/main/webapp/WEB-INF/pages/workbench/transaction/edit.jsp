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
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js" ></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" >
	//模态窗口数据渲染属性
	let activities = null;
	let contacts = null;

	//表单验证属性
	let isName_expectedDate_customer_stage = false;
	let isMoney = true;

	/**
	 * 渲染市场活动源
	 * @param activities
	 */
	function renderActivities(activities){
		let html = "";

		activities.forEach(activity => {
			html += "<tr id='tr_"+activity.id+"'>";
			if (activity.name == '${transaction.activityId}') {
				html += "	<td><input activityId='"+activity.id+"' type=\"radio\" name=\"activity\" checked></td>";
			}else {
				html += "	<td><input activityId='"+activity.id+"' type=\"radio\" name=\"activity\"></td>";
			}
			html += "	<td>"+activity.name+"</td>";
			html += "	<td>"+activity.startDate+"</td>";
			html += "	<td>"+activity.endDate+"</td>";
			html += "	<td>"+activity.owner+"</td>";
			html += "</tr>";
		})

		$("#tbody-searchActivityModal").html(html);
	}

	/**
	 * 渲染联系人
	 * @param contacts
	 */
	function renderContacts(contacts){
		let html = "";

		contacts.forEach(contact => {
			html += "<tr id='tr_"+contact.id+"'>";
			if (contact.fullname === '${transaction.contactsId}') {
				html += "	<td><input contactId='"+contact.id+"' type=\"radio\" name=\"contact\" checked/></td>";
			}else {
				html += "	<td><input contactId='"+contact.id+"' type=\"radio\" name=\"contact\"/></td>";
			}
			html += "	<td>"+contact.fullname+"</td>";
			html += "	<td>"+contact.email+"</td>";
			html += "	<td>"+contact.mphone+"</td>";
			html += "</tr>";
		})

		$("#tbody-searchContactsModal").html(html);
	}

	/**
	 * 表单验证
	 */
	function judgeAll(){
		const owner = $("#edit-owner").val()
		const money = $("#edit-money").val()
		const name = $("#edit-name").val()
		const expectedDate = $("#edit-expected-date").val()
		const customerId = $("#edit-customer-id").val()
		const stage = $("#edit-stage").val()

		isName_expectedDate_customer_stage = (owner != "" && name != "" && expectedDate != "" && customerId != "" && stage != "");
		isMoney = (money == "" ? true : /^[+]?\d*$/.test(money));

		$("#save").prop("disabled",!(isName_expectedDate_customer_stage && isMoney))
	}

	/**
	 * 入口函数
	 */
	$(function (){

		/**
		 * 弹出市场活动模态窗口
		 */
		$("#bundle-activity").click(function (){
			if (activities == null) {
				$.ajax({
					type:'post',
					url:'workbench/transaction/getAllActivities.do',
					success(data){
						activities = data.activities;
						renderActivities(activities);
					}
				})
			}

			$("#findMarketActivity").modal("show");
		})
		//模糊查询 市场活动
		$("#input-search-activities").keyup(function (){
			const name = $(this).val();
			let newActivities = activities.filter(item => item.name.includes(name));
			renderActivities(newActivities);
		})
		//用户选中市场活动
		$("#tbody-searchActivityModal").on("click","input[type='radio']",function (){
			const activityId = $(this).attr("activityId");//获取市场活动id
			//向服务器请求 市场活动对象
			let activity = activities.filter(activity => activity.id === activityId);
			//关闭模态窗口
			$("#findMarketActivity").modal("hide");
			$("#edit-activity-id").val(activity[0].name).attr("activityId",activityId);
		})

		/**
		 * 弹出 联系人模态窗口
		 */
		$("#bundle-contact").click(function (){
			if (contacts == null) {
				$.ajax({
					type: "post",
					url:'workbench/transaction/getAllContacts.do',
					success(data) {
						contacts = data.contacts;
						renderContacts(contacts);
					}
				})
			}

			$("#findContacts").modal("show");
		})
		//模糊查询 联系人名
		$("#input-search-contact").keyup(function (){
			const fullname = $(this).val();
			let newContacts = contacts.filter(contact => contact.fullname.includes(fullname));
			renderContacts(newContacts);
		})
		//用户选中联系人
		$("#tbody-searchContactsModal").on('click','input[type="radio"]',function (){
			const contactId = $(this).attr("contactId");//获取联系人id

			let contact = contacts.filter(contact => contact.id === contactId);
			//关闭模态窗口
			$("#findContacts").modal("hide");
			//显示数据
			$("#edit-contacts-id").val(contact[0].fullname).attr("contactsId",contactId);
		})

		/**
		 * 输入规则判断
		 */
		$(".form-horizontal:eq(0) input,.form-horizontal:eq(0) textarea").keyup(function (){
			judgeAll();
		})
		$("#edit-stage,#edit-expected-date").change(function (){
			judgeAll();
		})

		/**
		 * 可行性
		 */
		$("#edit-stage").change(function (){
			const stage = $(this).find('option:checked').text();//获取用户选中的阶段文字
			if (stage != "" && stage != undefined) {
				$.ajax({
					type:'post',
					url:'workbench/transaction/stageAnalyse.do',
					data:{
						stage:stage,
					},
					success(data){
						if (data.code = "1") {
							$("#edit-possibility").val(data.data);
						}
					}
				})
			}else{
				$("#edit-possibility").val("loading...");
			}
		})

		/**
		 * 自动补全客户名称
		 */
		$("#edit-customer-id").typeahead({
			source(jquery,process){
				$.ajax({
					type:'post',
					url:'workbench/transaction/getCustomerByName.do',
					data:{
						customerName:jquery
					},
					success(data){
						if (data.code = "1") {
							let stage = [];

							let stageDate = data.data;

							stage = stageDate.map(item => item.name);

							process(stage)
						}
					}
				})
			}
		})

		/**
		 * 保存交易
		 */
		$("#save").click(function (){
			const owner = $("#edit-owner").val();
			const money = $("#edit-money").val().trim();
			const name = $("#edit-name").val().trim();
			const expectedDate = $("#edit-expected-date").val();
			const customerId = $("#edit-customer-id").val().trim();
			const stage = $("#edit-stage").val();
			const type = $("#edit-type").val();
			const possibility = $("#edit-possibility").val();
			const source = $("#edit-source").val();
			const activityId = $("#edit-activity-id").attr("activityId");
			const contactsId = $("#edit-contacts-id").attr("contactsId");
			const description = $("#edit-description").val().trim();
			const contactSummary = $("#edit-contactSummary").val().trim();
			const nextContactTime = $("#edit-nextContactTime").val();

			$.ajax({
				type:'post',
				url:'workbench/transaction/updateTransaction.do',
				data:{
					id:'${transaction.id}',
					owner:owner,
					money:money,
					name:name,
					expectedDate:expectedDate,
					customerId:customerId,
					stage:stage,
					type:type,
					possibility:possibility,
					source:source,
					activityId:activityId,
					contactsId:contactsId,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime
				},
				success(data){
					if (+data.code) {
						window.location.href = "workbench/transaction/index.do";
					}else {
						alert(data.message)
					}
				}
			})
		})

		/**
		 * 日历插件
		 */
		$("#edit-nextContactTime,#edit-expected-date").datetimepicker({
			format:"yyyy-mm-dd",//日期格式
			language:"zh-CN",//语言
			minView:'month',
			initialDate:new Date(),//初始化时显示当前日期
			autoclose:true,//设置选择完日期或时间之后，是否自动关闭日历
			clearBtn:true,//设置是否显示清空按钮，默认为false
			todayBtn:true//设置是否显示今日按钮
		});

	})

	/**
	 * 加载交易数据
	 */
	$(function (){
		//页面加载完成后输入数据
		$("#edit-owner").val('${transaction.owner}')
		$("#edit-money").val('${transaction.money}')
		$("#edit-name").val('${transaction.name}')
		$("#edit-expected-date").val('${transaction.expectedDate}')
		$("#edit-customer-id").val('${transaction.customerId}')
		$("#edit-stage").val('${transaction.stage}')
		$("#edit-type").val('${transaction.type}')
		$("#edit-possibility").val('loading...')
		$("#edit-source").val('${transaction.source}')
		$("#edit-activity-id").val('${transaction.activityId}')
		$("#edit-contacts-id").val('${transaction.contactsId}')
		$("#edit-description").val('${transaction.description}')
		$("#edit-contactSummary").val('${transaction.contactSummary}')
		$("#edit-nextContactTime").val('${transaction.nextContactTime}')
	})
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="input-search-activities" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tbody-searchActivityModal">
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="input-search-contact" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="tbody-searchContactsModal">
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="save" type="button" class="btn btn-primary" disabled>保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>

	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<%--edit-owner--%>
		<%--edit-money--%>
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<%--edit-owner--%>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">
					<c:forEach items="${users}" var="user">
						<option value="${user.id}" >${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<%--edit-money--%>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money">
			</div>
		</div>
		<%--edit-name--%>
		<%--edit-expected-date--%>
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name">
			</div>
			<label for="edit-expected-date" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-expected-date" readonly>
			</div>
		</div>
		<%--edit-customer-id--%>
		<%--edit-stage--%>
		<div class="form-group">
			<label for="edit-customer-id" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customer-id" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-stage">
					<option></option>
					<c:forEach items="${stages}" var="stage">
						<option value="${stage.id}">${stage.value}</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<%--edit-type--%>
		<%--edit-possibility--%>
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
					<option></option>
					<c:forEach items="${types}" var="type">
						<option value="${type.id}">${type.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility">
			</div>
		</div>
		<%--edit-source--%>
		<%--edit-activity-id--%>
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
					<option></option>
					<c:forEach items="${sources}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activity-id" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="bundle-activity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activity-id" readonly>
			</div>
		</div>
		<%--edit-contacts-id--%>
		<div class="form-group">
			<label for="edit-contacts-id" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="bundle-contact"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contacts-id" readonly>
			</div>
		</div>
		<%--edit-description--%>
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description"></textarea>
			</div>
		</div>
		<%--edit-contactSummary--%>
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
			</div>
		</div>
		<%--edit-nextContactTime--%>
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-nextContactTime" readonly>
			</div>
		</div>

	</form>
</body>
</html>