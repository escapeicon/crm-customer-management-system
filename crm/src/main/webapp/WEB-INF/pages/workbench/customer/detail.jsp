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
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js" ></script>

<script type="text/javascript">
	let isName = false;//名字是否为空
	let isMphone = true;//手机号格式是否正确
	let isEmail = true;//邮箱格式是否正确

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

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
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		$("#remarkDivList").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkDivList").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});
		$("#remarkDivList").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});
		$("#remarkDivList").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		/**
		 * 备注
		 */
		//保存备注
		$("#saveBtn").click(function (){
			const noteContent = $("#remark").val().trim();//获取用户输入的备注信息

			if (noteContent != "") {
				$.ajax({
					type:'post',
					url:'workbench/customer/addCustomerRemark.do',
					data:{
						noteContent:noteContent,
						customerId:'${customer.id}'
					},
					success(data){
						if (+data.code) {
							const customerRemark = data.data;

							let html = "";

							//渲染列表
							html += "<div id='div_"+customerRemark.id+"' class=\"remarkDiv\" style=\"height: 60px;\">";
							html += "	<img title=\"${customer.createBy}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							html += "		<div style=\"position: relative; top: -40px; left: 40px;\">";
							html += "			<h5>"+customerRemark.noteContent+"</h5>";
							html += "			<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${customer.name}</b> <small style=\"color: gray;\"> "+customerRemark.createTime+" 由 ${customer.createBy} 创建</small>";
							html += "			<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							html += "				<a remarkid="+customerRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							html += "				&nbsp;&nbsp;&nbsp;&nbsp;";
							html += "				<a remarkid="+customerRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							html += "			</div>";
							html += "		</div>";
							html += "</div>";

							$("#remarkDiv").before(html);
							$("#remark").val("");
						}else {
							alert(data.message);
						}
					}
				})
			}else {
				alert("请输入内容再进行保存操作!");
			}
		})
		//加载修改备注模态窗口数据
		$(document).on("click",".myHref:even",function (){
			const remarkId = $(this).attr("remarkId");
			$.ajax({
				type:'post',
				url:'workbench/customer/editCustomerRemark.do',
				data:{
					id:remarkId
				},
				success(data) {
					$("#noteContent").val(data.noteContent)
					$("#remarkId").val(data.id);
					$("#editRemarkModal").modal("show");
				}
			})
		})
		//修改备注
		$("#updateRemarkBtn").click(function (){
			const noteContent = $("#noteContent").val().trim();
			const id = $("#remarkId").val();

			$.ajax({
				type:'post',
				url:'workbench/customer/saveEditedCustomerRemark.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				success(data){
					if (+data.code) {
						const customerRemark = data.data;//获取客户备注

						let html = "";
						//渲染网页
						html += "<img title='${customer.owner}' src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						html += "<div style=\"position: relative; top: -40px; left: 40px;\">";
						html += "	<h5>"+customerRemark.noteContent+"</h5>";
						html += "	<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${customer.name}</b> <small style=\"color: gray;\"> "+customerRemark.editTime+" 由 ${user.name} 修改</small>";
						html += "	<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "		<a remarkid="+customerRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "		&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "		<a remarkid="+customerRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "	</div>";
						html += "</div>";

						$("#div_"+customerRemark.id).html(html);
						$("#editRemarkModal").modal("hide");
					}else {
						alert(data.message);
					}
				}
			})
		})
		//删除备注
		$(document).on("click",".myHref:odd",function (){
			const remarkId = $(this).attr("remarkId");

			$.ajax({
				type:'post',
				url:"workbench/customer/deleteCustomerRemark.do",
				data:{
					id:remarkId
				},
				success(data){
					if (+data.code) {
						$("#div_"+remarkId).remove();
					}else {
						alert(data.message);
					}
				}
			})
		})

		/**
		 * 交易
		 */
		//删除交易
		$("#tbody-transaction").on("click","a:odd",function (){
			if (confirm("你确定删除吗?")) {
				const transactionId = $(this).attr("transactionId");
				$.ajax({
					type:'post',
					url:'workbench/customer/deleteTransaction.do',
					data:{
						id:transactionId
					},
					success(data){
						if (+data.code) {
							$("#tr_"+transactionId).remove();
						}else {
							alert(data.message);
						}
					}
				})
			}
		})
		//跳转至交易详情页
		$("#tbody-transaction").on("click","a:even",function (){
			const transactionId = $(this).attr("transactionId");//获取交易id
			window.location.href = "workbench/transaction/toTransactionDetail.do?transactionId="+transactionId;
		})

		/**
		 * 联系人
		 */
		//手动调出创建联系人模态窗口
		$("#create-contacts").click(function (){
			$("#createContactsModal").modal("show");
		})
		//对创建联系人表单验证
		$("#create-fullname,#create-mphone,#create-email").keyup(function (){
			judgeAll("create");
		})
		//客户名称自动补全
		$("#create-customer").typeahead({
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
		//提交创建
		$("#create-btn").click(function (){
			const contact = getAllInput("create");

			$.ajax({
				type:'post',
				url:'workbench/contacts/addOneContact.do',
				contentType:'application/json',
				data:JSON.stringify(contact),
				success(data) {
					if (+data.code) {
						window.location.reload();

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
		//删除联系人
		$("#tbody-contacts").on("click","a:odd",function (){
			if (confirm("你确认要删除该联系人吗?")) {
				const contactId = $(this).attr("contactId");//交易id

				$.ajax({
					type:'post',
					url:'workbench/customer/deleteContactById.do',
					data:{
						contactId:contactId,
					},
					success(data){
						if (+data.code) {
							window.location.reload();
						}else {
							alert(data.message);
						}
					}
				})
			}
		})
		//前往detail页面
		$("#tbody-contacts").on("click","a:even",function (){
			const contactId = $(this).attr("contactId");//交易id
			window.location.href = "workbench/customer/toContactDetail.do?contactId="+contactId;
		})

		/**
		 * 日历组件
		 */
		$("#create-nextContactTime").datetimepicker({
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
					<button id="create-btn" type="button" class="btn btn-primary" disabled>保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<%--modal-body--%>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.location.href = 'workbench/customer/index.do';"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${customer.name} <small><a href="http://www.bjpowernode.com" target="_blank">${customer.website}</a></small></h3>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner} &nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name} &nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website} &nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone} &nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.contactSummary}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}&nbsp;</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.description}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: 'gray';">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.address}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<c:forEach items="${customerRemarks}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;"> ${remark.editFlag == '1' ? remark.editTime : remark.createTime} 由 ${remark.editFlag == '1' ? remark.editBy : remark.createBy} ${remark.editFlag == '1' ? "修改" : "创建"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a remarkId="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a remarkId="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tbody-transaction">
						<c:forEach items="${transactions}" var="transaction">
							<tr id="tr_${transaction.id}">
								<td><a transactionId="${transaction.id}" href="javascript:void(0);" style="text-decoration: none;">${transaction.customerId}-${transaction.name}</a></td>
								<td>${transaction.money}</td>
								<td>${transaction.stage}</td>
								<td>${transaction.possibility}</td>
								<td>${transaction.expectedDate}</td>
								<td>${transaction.type}</td>
								<td><a transactionId="${transaction.id}" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/toTransactionSavePage.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tbody-contacts">
						<c:forEach items="${contacts}" var="contact">
							<tr>
								<td><a contactId="${contact.id}" href="javascript:void(0);" style="text-decoration: none;">${contact.fullname}</a></td>
								<td>${contact.email}</td>
								<td>${contact.mphone}</td>
								<td><a contactId="${contact.id}" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="create-contacts" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>