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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	//存放市场活动源 数据数组
	let activities = null;
	
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
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		/**
		 * 联系人备注
		 */
		//添加联系人备注
		$("#saveBtn").click(function (){
			const noteContent = $("#remark").val().trim();//获取备注信息

			$.ajax({
				type:'post',
				url:'workbench/contacts/saveContactRemark.do',
				data:{
					noteContent:noteContent,
					contactId:'${contact.id}'
				},
				success(data) {
					if (+data.code) {
						const contactRemark = data.data;

						$("#remark").val("");

						let html = "";

						html += "<div id='div_"+contactRemark.id+"' className=\"remarkDiv\" style=\"height: 60px;\">";
						html += "	<img title='${contact.owner}' src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						html += "		<div style=\"position: relative; top: -40px; left: 40px;\">";
						html += "			<h5>"+contactRemark.noteContent+"</h5>";
						html += "			<font color=\"gray\">联系人</font> <font color=\"gray\">-</font> <b>${contact.fullname}${contact.appellation}-${contact.customer}</b> <small style=\"color: gray;\">"+ contactRemark.createTime +"由${contact.createBy}创建</small>";
						html += "			<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "				<a remarkId="+contactRemark.id+" className=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "				&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "				<a remarkId="+contactRemark.id+" className=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "			</div>";
						html += "		</div>";
						html += "</div>";

						$("#remarkDiv").before(html);
					}else {
						alert(data.message);
					}
				}
			})
		})
		//加载修改备注模态窗口数据
		$(document).on("click",".myHref:even",function (){
			const remarkId = $(this).attr("remarkId");
			$.ajax({
				type:'post',
				url:'workbench/contacts/loadEditContactRemark.do',
				data:{
					contactRemarkId:remarkId
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
				url:'workbench/contacts/saveEditedContactRemark.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				success(data){
					if (+data.code) {
						const contactRemark = data.data;//获取客户备注

						let html = "";
						//渲染网页
						html += "<img title='${contact.owner}' src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						html += "<div style=\"position: relative; top: -40px; left: 40px;\">";
						html += "	<h5>"+contactRemark.noteContent+"</h5>";
						html += "	<font color=\"gray\">联系人</font> <font color=\"gray\">-</font> <b>${contact.fullname}-${contact.customer}</b> <small style=\"color: gray;\"> "+contactRemark.editTime+" 由 ${contact.owner} 修改</small>";
						html += "	<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "		<a remarkid="+contactRemark.id+" className=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "		&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "		<a remarkid="+contactRemark.id+" className=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "	</div>";
						html += "</div>";

						$("#div_"+contactRemark.id).html(html);
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
				url:"workbench/contacts/deleteContactsRemark.do",
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
			if (confirm("你确定要删除该交易吗?")) {
				const transactionId = $(this).attr("transactionId");//获取交易id

				$.ajax({
					type:'post',
					url:"workbench/contacts/deleteTransactionById.do",
					data:{
						transactionId:transactionId
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

		/**
		 * 市场活动
		 */
		$("#bundleActivities").click(function (){
			//发送ajax请求获取 除过已经绑定了的所有市场活动
			$.ajax({
				type:'post',
				url:'workbench/contacts/getAllActivitiesExcluedBundled.do',
				data:{
					contactId:'${contact.id}'
				},
				success(data){
					if (+data.code) {
						activities = data.data;
						renderActivitiesForModal(activities);
					}else {
						alert(data.message);
					}
				}
			})

			//显示模态窗口
			$("#bundActivityModal").modal("show");
		})
		//实时搜索
		$("#input-search-activities-fuzzy").keyup(function (){
			const activityName = $(this).val();
			let newActivities = activities.filter(activity => activity.name.includes(activityName));
			renderActivitiesForModal(newActivities);
		})
		//全选 && 反选
		$("#checkAll-activities").click(function (){
			$("#tbody-modal-activities input[type='checkbox']").prop("checked",$("#checkAll-activities").prop("checked"));
		})
		$("#tbody-modal-activities").on("click","input[type='checkbox']",function (){
			$("#checkAll-activities").prop("checked",$("#tbody-modal-activities input[type='checkbox']:checked").length == $("#tbody-modal-activities input[type='checkbox']").length);
		})
		//关联市场活动
		$("#bundleBtn").click(function (){
			const activitiesCheckBox = $("#tbody-modal-activities input[type='checkbox']:checked");
			if (activitiesCheckBox.length > 0) {

				let activityIds = [];

				activitiesCheckBox.each(function (){
					activityIds.push($(this).val())
				})

				//发送ajax请求
				$.ajax({
					type:'post',
					url:'workbench/contacts/bundleContactActivity.do',
					traditional:true,
					data:{
						activityIds:activityIds,
						contactId:'${contact.id}'
					},
					success(data){
						if (+data.code) {
							//获取绑定的市场活动对象
							bundledActivities = activities.filter(activity => activityIds.includes(activity.id));

							//渲染页面
							let html = "";
							bundledActivities.forEach(activity => {
								html += "<tr id='tr_"+activity.id+"'>";
								html += "	<td><a activityid='"+activity.id+"' style=\"text-decoration: none;\">"+activity.name+"</a></td>";
								html += "	<td>"+activity.startDate+"</td>";
								html += "	<td>"+activity.endDate+"</td>";
								html += "	<td>"+activity.owner+"</td>";
								html += "	<td><a href=\"javascript:void(0);\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
								html += "</tr>";
							})
							$("#tbody-activities").append(html);

							//关闭模态窗口
							$("#bundActivityModal").modal("hide");
						}else {
							alert(data.message);
						}
					}
				})

			}else {
				alert("请至少选择一个市场活动进行关联...");
			}
		})
		//解除市场活动关联
		$("#tbody-activities").on("click","a:odd",function(){
			if (confirm("你确认解绑该条市场活动吗?")) {
				const activityId = $(this).attr("activityId");

				$.ajax({
					type:'post',
					url:'workbench/contacts/unBundleContactActivity.do',
					data:{
						activityId:activityId,
						contactId:'${contact.id}'
					},
					success(data){
						if (+data.code) {
							$("#tr_"+activityId).remove();
						}else {
							alert(data.message);
						}
					}
				})
			}
		})
		//前往市场活动详情页
		$("#tbody-activities").on("click","a:even",function(){
			const activityId = $(this).attr("activityId");
			window.location.href = "workbench/contacts/toActivityDetail.do?activityId="+activityId;
		})
	});

	/**
	 * 渲染市场活动模态窗口列表方法
	 * @param activities
	 */
	function renderActivitiesForModal(activities){

		let html = "";

		activities.forEach(function (activity){
			html += "<tr>";
			html += "	<td><input value='"+activity.id+"' type=\"checkbox\"/></td>";
			html += "	<td>"+activity.name+"</td>";
			html += "	<td>"+activity.startDate+"</td>";
			html += "	<td>"+activity.endDate+"</td>";
			html += "	<td>"+activity.owner+"</td>";
			html += "</tr>";
		})

		$("#tbody-modal-activities").html(html);
	}
	
</script>

</head>
<body>

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<%--模糊查询input--%>
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="input-search-activities-fuzzy" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkAll-activities" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tbody-modal-activities">
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="bundleBtn" type="button" class="btn btn-primary">关联</button>
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
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${contact.fullname}${contact.appellation} <small> - ${contact.customer}</small></h3>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.source == null ? '&nbsp;' : contact.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.customer == null ? '&nbsp;' : contact.customer}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.fullname}${contact.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.email == "" ? '&nbsp;' : contact.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.mphone == "" ? '&nbsp;' : contact.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.job == "" ? '&nbsp;' : contact.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contact.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contact.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contact.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contact.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contact.description == "" ? '&nbsp;' : contact.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contact.contactSummary == "" ? '&nbsp;' : contact.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.nextContactTime == "" ? '&nbsp;' : contact.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${contact.address == "" ? '&nbsp;' : contact.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<c:forEach items="${contactsRemarks}" var="contactRemark">
		<div id="div_${contactRemark.id}" class="remarkDiv" style="height: 60px;">
			<img title="${contact.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${contactRemark.noteContent}</h5>
				<font color="gray">联系人</font> <font color="gray">-</font> <b>${contact.fullname}${contact.appellation}-${contact.customer}</b> <small style="color: gray;"> ${contactRemark.editFlag == '1' ? contactRemark.editTime : contactRemark.createTime} 由${contactRemark.editFlag == '1' ? contactRemark.editBy : contactRemark.createBy} ${contactRemark.editFlag == '1' ? '修改' : '创建'}</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a remarkId="${contactRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a remarkId="${contactRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
						<tr>
							<td><a transactionId="${transaction.id}" style="text-decoration: none;">${transaction.customerId}-${transaction.name}</a></td>
							<td>${transaction.money}</td>
							<td>${transaction.stage}</td>
							<td>待定</td>
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
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tbody-activities">
						<c:forEach items="${activities}" var="activity">
						<tr id="tr_${activity.id}">
							<td><a activityId="${activity.id}" href="javascript:void(0);" style="text-decoration: none;">${activity.name}</a></td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a activityId="${activity.id}" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bundleActivities" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>