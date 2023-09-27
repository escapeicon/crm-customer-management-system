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

	//保存市场活动页面的分页组件参数
	let pageNo = '${pageNo}';
	let pageSize = '${pageSize}';
	
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

		//---------------------------添加市场活动备注
		$("#saveBtn").click(function (){
			let noteContent = $("#remark").val().trim();//获取市场活动备注信息
			//let activityId = ;//获取市场活动id
			if (noteContent) {
				//发送ajax请求
				$.ajax({
					type:'post',
					url:'workbench/activity/saveActivityRemark.do',
					data:{
						noteContent:noteContent,
						activityId:'${activity.id}'
					},
					success(data){
						const code = data.code;
						if (code) {
							$("#remark").val("");//清空输入框
							const remark = data.data;//获取市场活动备注信息

							//拼接字符串
							let html = "";

							html += "<div id='div_"+remark.id+"' class=\"remarkDiv\" style=\"height: 60px;\">"
							html += "<img title=\""+'${userInfo.name}'+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							html += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
							html += "<h5 id=\"h5_"+remark.id+"\">"+remark.noteContent+"</h5>";
							html += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>"+'${activity.name}'+"</b> <small style=\"color: gray;\">"+remark.createTime+"由"+'${userInfo.name}'+"创建</small>";
							html += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							html += "<a remarkId=\""+remark.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							html += "&nbsp;&nbsp;&nbsp;&nbsp;";
							html += "<a remarkId=\""+remark.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							html += "</div></div></div>";

							$("#remarkDiv").before(html);
						}else{
							alert(data.message);//提示错误信息
						}
					}
				})
			}else{
				alert("备注栏不能为空!");
			}
		})

		//-----------------------------删除市场活动备注
		$("#remarkDivList").on("click",".myHref:odd",function (){
			let id = $(this).attr("remarkId");//获取id属性
			//发送ajax请求
			$.ajax({
				type:'post',
				url:'workbench/activity/deleteActivityRemark.do',
				data:{
					id:id
				},
				dataType:"json",
				success(data){
					if (data) {
						$("#div_"+id).remove();//删除市场活动备注标签
					}else{
						alert(data.message);
					}
				}
			})
		})

		//---------------------修改市场活动备注
		/**
		 * 弹出修改市场活动备注模态窗口
		 */
		$("#remarkDivList").on("click",".myHref:even",function(){
			//弹出市场活动备注修改的模态窗口
			$("#editRemarkModal").modal("show");
			//获取市场活动备注的id
			let remarkId = $(this).attr("remarkId");
			//获取市场活动备注的内容
			let noteContent = $("#h5_"+remarkId).text();
			//给隐藏输入框添加市场活动备注id
			$("#remarkId").val(remarkId);
			//给模态窗口的内容区域填充备注
			$("#noteContent").val(noteContent);
		})
		/**
		 * 修改市场活动备注提交事件
		 */
		$("#updateRemarkBtn").click(function (){
			//获取市场活动备注id
			const remarkId = $("#remarkId").val();
			//获取市场活动备注内容
			let noteContent = $("#noteContent").val().trim();
			//发送ajax请求
			$.ajax({
				type:'post',
				url:'workbench/activity/updateActivityRemark.do',
				dataType:'json',
				data:{
					id:remarkId,
					noteContent:noteContent
				},
				success(data){
					if (data.code) {
						const remark = data.data;//获取返回的市场活动备注信息
						$("#noteContent").val("");//清空模态窗口输入框内容
						$("#editRemarkModal").modal("hide");//关闭模态窗口

						//修改市场活动备注信息
						//拼接字符串
						let html = "";

						html += "<img title=\""+'${userInfo.name}'+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						html += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
						html += "<h5 id=\"h5_"+remark.id+"\">"+remark.noteContent+"</h5>";
						html += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>"+'${activity.name}'+"</b> <small style=\"color: gray;\">"+remark.editTime+"由"+'${userInfo.name}'+"修改</small>";
						html += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "<a remarkId=\""+remark.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "<a remarkId=\""+remark.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "</div></div>";

						$("#div_"+remarkId).html(html);
					}else{
						alert(data.message);
					}
				}
			})

		})


		/**
		 * 跳转回市场活动展示页面方法
		 */
		$("#backToActivityIndex").click(function(){
			window.location.href = "workbench/activity/index.do?pageNo="+pageNo+"&pageSize="+pageSize;
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
		<a id="backToActivityIndex" href="javascript:void(0);"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ${activity.startDate == null ? '' : '~'} ${activity.endDate}</small></h3>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activity-name">${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${activityRemarks}" var="activityRemark">
			<!-- 备注1 -->
			<div id="div_${activityRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${activityRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h5_${activityRemark.id}">${activityRemark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> ${activityRemark.editFlag == '1' ? activityRemark.editTime : activityRemark.createTime} 由${activityRemark.editFlag == '1' ? activityRemark.editBy : activityRemark.createBy}${activityRemark.editFlag == '1' ? '修改' : '创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a remarkId="${activityRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a remarkId="${activityRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
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
	<div style="height: 200px;"></div>
</body>
</html>