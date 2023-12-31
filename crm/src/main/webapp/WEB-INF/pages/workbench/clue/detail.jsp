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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	//该线索未绑定的市场活动数组 用于渲染绑定市场活动数组功能
	let activities = null;

	/**
	 * 渲染绑定市场活动页面的方法
	 * @param activities
	 */
	function renderActivities(activities){

		let html = "";

		activities.forEach(item => {
			html += "<tr>";
			html += "	<td><input value=\""+item.id+"\" type=\"checkbox\"/></td>";
			html += "	<td>"+item.name+"</td>";
			html += "	<td>"+item.startDate+"</td>";
			html += "	<td>"+item.endDate+"</td>";
			html += "	<td>"+item.owner+"</td>";
			html += "</tr>";
		})

		$("#bund-activity-tbody").html(html);//渲染页面
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

		//保存线索备注按钮
		$("#save-clue-remark-btn").click(function (){
			let remark = $("#remark").val().trim();//获取用户输入的备注信息
			if (remark != "" && remark != null) {
				$.ajax({
					type:'post',
					url:'workbench/clue/saveClueRemark.do',
					data:{
						noteContent:remark,
						clueId:'${clue.id}'
					},
					success(data){
						if (data.code = "1") {
							const clueRemark = data.data;//获取线索备注实体类
							$("#remark").val("");//清空备注栏
							//拼接html标签
							let html = "";

							html += "<div id=\"div_"+clueRemark.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							html += "	<img title=\"${userInfo.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
							html += "	<div style=\"position: relative; top: -40px; left: 40px;\" >";
							html += "		<h5>"+clueRemark.noteContent+"</h5>";
							html += "		<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+ clueRemark.createTime +"由 ${userInfo.name} 创建</small>";
							html += "		<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							html += "			<a clueRemarkId=\""+clueRemark.id+"\" class=\"myHref\"  href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							html += "			&nbsp;&nbsp;&nbsp;&nbsp;";
							html += "			<a clueRemarkId=\""+clueRemark.id+"\" class=\"myHref\"  href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							html += "</div></div></div>";

							$("#remarkDiv").before(html);

						}
					}
				})
			}else{
				alert("请输入线索备注信息!")
			}
		})

		//删除线索备注按钮
		$("#remarkDivList").on("click",'a:odd',function (){
			const remarkId = $(this).attr("clueRemarkId");
			$.ajax({
				url:"workbench/clue/deleteClueRemarkById.do",
				type:'post',
				data:{
					id:remarkId
				},
				success(data) {
					if (data.code = "1") {
						$("#div_"+remarkId).remove();
					}else{
						alert(data.message);
					}
				}
			})
		})

		//修改线索备注按钮
		$("#remarkDivList").on("click","a:even",function (){
			const remarkId = $(this).attr("clueRemarkId");//获取线索备注id
			let noteContent = $("#div_" + remarkId + " h5").text();//获取线索备注的noteContent
			$("#noteContent").val(noteContent);//设置修改模态窗口内容框显示内容
			$("#remarkId").val(remarkId);//设置模态窗口隐藏框的id值
			$("#editRemarkModal").modal("show");
		})
		//保存修改线索备注按钮
		$("#updateRemarkBtn").click(function (){

			const noteContent = $("#noteContent").val().trim();//获取用户输入的noteContent内容
			const remarkId = $("#remarkId").val();//获取要修改的线索备注的id值

			$.ajax({
				type:'post',
				url:'workbench/clue/updateClueRemarkById.do',
				data:{
					id:remarkId,
					noteContent:noteContent
				},
				success(data){
					if (data.code = "1") {
						const clueRemark = data.data;

						//拼接html标签
						let html = "";

						html += "	<img title=\"${userInfo.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
						html += "	<div style=\"position: relative; top: -40px; left: 40px;\" >";
						html += "		<h5>"+clueRemark.noteContent+"</h5>";
						html += "		<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+ clueRemark.createTime +"由 ${userInfo.name} 修改</small>";
						html += "		<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "			<a clueRemarkId=\""+clueRemark.id+"\" class=\"myHref\"  href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "			&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "			<a clueRemarkId=\""+clueRemark.id+"\" class=\"myHref\"  href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "</div></div>";

						$("#div_"+remarkId).html(html);

						$("#editRemarkModal").modal("hide");

					}else {
						alert(data.message);
					}
				}
			})
		})

		//关联市场活动按钮
		$("#bund-activity-btn").click(function (){

			//清空输入框信息
			$("#input-activity-fuzzy-query").val("");

			//发送ajax请求
			$.ajax({
				type:'post',
				url:'workbench/clue/uploadBundleList.do',
				data:{
					clueId:'${clue.id}'
				},
				success(data){
					if (data.code = "1") {
						activities = data.data;//获取市场活动信息
						renderActivities(activities);//渲染市场活动列表
						$("#bundModal").modal("show")//显示绑定页面
					}else {
						alert("系统繁忙，请稍后重试...")
					}
				}
			})
		})
		//模糊查询市场活动名称
		$("#input-activity-fuzzy-query").keyup(function (){
			let inputName = $("#input-activity-fuzzy-query").val().trim();//用户输入的市场活动名称
			let newActivities = activities.filter(item => item.name.includes(inputName))//获取市场活动数组中name包含用户输入字段的项
			renderActivities(newActivities);//重新渲染待绑定的市场活动列表
		})
		//市场活动全选反选
		$("#check-all-activities").change(function (){
			$("#bund-activity-tbody input[type='checkbox']").prop("checked",$("#check-all-activities").prop("checked"));
			//根据用户点击市场活动判断是否禁用绑定按钮 用于用户提交时至少选择一个市场活动进行绑定
			$("#bundle-activity-btn").prop("disabled",!$("#check-all-activities").prop("checked"));
		})
		//市场列表全选 -> 全选按钮checked
		$("#bund-activity-tbody").on("change","input[type='checkbox']",function (){
			$("#check-all-activities").prop("checked",$("#bund-activity-tbody input[type='checkbox']").size() == $("#bund-activity-tbody input[type='checkbox']:checked").size())
			//根据用户点击市场活动判断是否禁用绑定按钮 用于用户提交时至少选择一个市场活动进行绑定
			$("#bundle-activity-btn").prop("disabled",!$("#bund-activity-tbody input[type='checkbox']:checked").size() > 0);
		})

		//关联市场活动
		$("#bundle-activity-btn").click(function (){
			let activityIds = [];//创建市场活动id数组
			const clueId = '${clue.id}';//获取线索id
			$("#bund-activity-tbody input[type='checkbox']:checked").each(function (){
				activityIds.push($(this).val());//添加用户选中的市场活动id
			})

			//发送ajax请求
			$.ajax({
				type:'post',
				url:'workbench/clue/saveClueActivityRelations.do',
				contentType:'application/json',
				data:JSON.stringify({
					clueId:clueId,
					activityIds:activityIds
				}),
				success(data){
					if (data.code = "1") {
						const bundledActivities = data.data;

						let html = "";

						bundledActivities.forEach(function (item){
							html += "<tr id=\"tr_"+item.id+"\">"
							html += "	<td>"+item.name+"</td>"
							html += "	<td>"+item.startDate+"</td>"
							html += "	<td>"+item.endDate+"</td>"
							html += "	<td>"+item.owner+"</td>"
							html += "	<td><a activityId=\""+item.id+"\" href=\"javascript:void(0);\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>"
							html += "</tr>"
						})

						//动态添加市场活动
						$("#tbody-activities").append(html);

						$("#bundModal").modal("hide")//关闭绑定页面
					}else{
						alert(data.message);
					}
				}
			})

		})
		//解除关联市场活动
		$("#tbody-activities").on("click","tr>td>a",function (){
			if (window.confirm("您确认删除该条关联的市场活动吗？")) {

				const activityId = $(this).attr("activityId");//获取市场活动id
				const clueId = '${clue.id}';//获取线索id

				//发送ajax请求
				$.ajax({
					type:'post',
					url:'workbench/clue/deleteClueActivityRelation.do',
					data:{
						activityId:activityId,
						clueId:clueId
					},
					success(data){
						if (data.code = "1") {
							$("#tr_"+activityId).remove();
						}else {
							alert(data.message);
						}
					}
				})
			}
		})

		//线索转换按钮
		$("#clue-convert-btn").click(function (){
			window.location.href = "workbench/clue/toClueConvert.do?clueId="+'${clue.id}';
		})

		//回退按钮
		$("#backToClue").click(function (){
			window.location.href = "workbench/clue/index.do";
		})
	});
	
</script>

</head>
<body>

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

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="input-activity-fuzzy-query" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<%--市场活动列表--%>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="check-all-activities" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="bund-activity-tbody">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="bundle-activity-btn" type="button" class="btn btn-primary" disabled>关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" id="backToClue"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="clue-convert-btn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<%--fullname owner--%>
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--company job--%>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--email phone--%>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--website mphone--%>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--state source--%>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--createBy createTime--%>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--editBy editTime--%>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--description--%>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--contactSummary--%>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--nextContactTime--%>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
		<%--address--%>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<c:forEach items="${clueRemarks}" var="clueRemark">
			<div id="div_${clueRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${clueRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${clueRemark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${clueRemark.editFlag == '0' ? clueRemark.createTime : clueRemark.editTime} 由${clueRemark.editFlag == '0' ? clueRemark.createBy : clueRemark.editBy}${clueRemark.editFlag == '0' ? "创建" : "修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a clueRemarkId="${clueRemark.id}" class="myHref"  href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a clueRemarkId="${clueRemark.id}" class="myHref"  href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>

		</c:forEach>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="save-clue-remark-btn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>

			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
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
							<td>${activity.name}</td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a activityId="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			<div>
				<a id="bund-activity-btn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>

	<div style="height: 200px;"></div>
</body>
</html>