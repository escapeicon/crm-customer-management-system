<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
<base href="<%= base%>" />
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
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
		 * 阶段提示框
		 */
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });
		//修改阶段
		$("#stageDiv").on("click","span",function (){
			const stageValue = $(this).attr("data-content");
			const orderNo = $(this).attr("orderNo");

			$.ajax({
				type:'post',
				url:'workbench/transaction/editStage.do',
				data:{
					stageValue:stageValue,
					transactionId:'${transaction.id}'
				},
				success(data){
					if (+data.code) {
						const possibility = data.data.possibility;
						const transactionHistory = data.data.transactionHistory;

						//修改阶段&可能性
						$("#b_stage").text(stageValue);
						$("#b_possibility").text(possibility)
						//添加一条成交历史
						let html = "";

						html += "<tr>";
						html += "	<td>"+transactionHistory.stage+"</td>";
						html += "	<td>"+transactionHistory.money+"</td>";
						html += "	<td>"+transactionHistory.expectedDate+"</td>";
						html += "	<td>"+transactionHistory.createTime+"</td>";
						html += "	<td>"+transactionHistory.createBy+"</td>";
						html += "</tr>";

						$("#tbody-transactionHistory tr:eq(0)").before(html);
					}else {
						alert(data.message);
					}
				}
			})

			renderStageList(orderNo);//动态渲染网页
		})

		/**
		 * 交易备注
		 */
		//添加交易备注
		$("#saveRemark").click(function (){
			const noteContent = $("#remark").val().trim();//获取备注信息

			$.ajax({
				type:'post',
				url:'workbench/transaction/saveTransactionRemark.do',
				data:{
					noteContent:noteContent,
					transactionId:'${transaction.id}'
				},
				success(data) {
					if (+data.code) {
						const transactionRemark = data.data;

						$("#remark").val("");

						let html = "";

						html += "<div id='div_"+transactionRemark.id+"' class=\"remarkDiv\" style=\"height: 60px;\">";
						html += "	<img title='"+transactionRemark.createBy+"' src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						html += "		<div style=\"position: relative; top: -40px; left: 40px;\">";
						html += "			<h5>"+transactionRemark.noteContent+"</h5>";
						html += "			<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${transaction.customerId}-${transaction.name}</b> <small style=\"color: gray;\">"+ transactionRemark.createTime +"由${transaction.createBy}创建</small>";
						html += "			<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "				<a remarkId="+transactionRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "				&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "				<a remarkId="+transactionRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
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
				url:'workbench/transaction/getUpdateTransactionRemark.do',
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
				url:'workbench/transaction/updateTransactionRemark.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				success(data){
					if (+data.code) {
						const transactionRemark = data.data;//获取客户备注

						let html = "";
						//渲染网页
						html += "<img title='${transaction.owner}' src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						html += "<div style=\"position: relative; top: -40px; left: 40px;\">";
						html += "	<h5>"+transactionRemark.noteContent+"</h5>";
						html += "	<font color=\"gray\">联系人</font> <font color=\"gray\">-</font> <b>${transaction.customerId}-${transaction.name}</b> <small style=\"color: gray;\"> "+transactionRemark.editTime+" 由 ${transaction.owner} 修改</small>";
						html += "	<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						html += "		<a remarkid="+transactionRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "		&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "		<a remarkid="+transactionRemark.id+" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						html += "	</div>";
						html += "</div>";

						$("#div_"+transactionRemark.id).html(html);
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
				url:"workbench/transaction/deleteTransactionRemark.do",
				data:{
					transactionRemarkId:remarkId
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
	});

	/**
	 * 渲染阶段链
	 */
	function renderStageList(orderNo){
		$("#stageDiv span").each(function (){
			const nodeOrderNo = $(this).attr("orderNo");//获取每个节点的orderNo
			if(orderNo > nodeOrderNo){
				$(this).attr("class","glyphicon glyphicon-ok-circle  mystage").css("color","#90F790");
			}else if(orderNo < nodeOrderNo){
				$(this).attr("class","glyphicon glyphicon-record mystage").css("color","#333");
			}else if(orderNo == nodeOrderNo){
				$(this).attr("class","glyphicon glyphicon-map-marker mystage").css("color","#90F790");
			}
		})
	}
	
</script>

</head>
<body>
	<!-- 修改备注的模态窗口 -->
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
			<h3>${transaction.customerId}-${transaction.name} <small>￥${transaction.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div id="stageDiv" style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<c:forEach items="${stages}" var="stage">

			<c:if test="${transaction.stage == stage.value}">
				<span orderNo="${stage.orderNo}" class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
				-----------
			</c:if>

			<c:if test="${transaction.stageOrderNo > stage.orderNo}" >
				<span orderNo="${stage.orderNo}" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
				-----------
			</c:if>

			<c:if test="${transaction.stageOrderNo < stage.orderNo}">
				<span orderNo="${stage.orderNo}" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
				-----------
			</c:if>

		</c:forEach>
		<span class="closingDate">${transaction.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<%--所有者 金额--%>
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.money == null ? '&nbsp;' : transaction.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--名称 预计成交日期--%>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.customerId}-${transaction.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--客户名称 阶段--%>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="b_stage">${transaction.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--类型 可能性--%>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.type == null ? '&nbsp;' : transaction.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="b_possibility">${transaction.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--来源	市场活动源--%>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.source == null ? '&nbsp;' : transaction.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.activityId == null ? '&nbsp;' : transaction.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<%--联系人名称--%>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.contactsId == null ? '&nbsp;' : transaction.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--创建者--%>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${transaction.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--修改者--%>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${transaction.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--描述--%>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${transaction.description == null ? '&nbsp;' : transaction.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--联系纪要--%>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${transaction.contactSummary == null ? '&nbsp;' : transaction.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<%--下次联系时间--%>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<c:forEach items="${transactionRemarks}" var="transactionRemark">
		<div id="div_${transactionRemark.id}" class="remarkDiv" style="height: 60px;">
			<img title="${transactionRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${transactionRemark.noteContent}</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>${transaction.customerId}-${transaction.name}</b> <small style="color: gray;"> ${transactionRemark.editFlag == "1" ? transactionRemark.editTime : transactionRemark.createTime} 由 ${transactionRemark.editFlag == "1" ? transactionRemark.editBy : transactionRemark.createBy} ${transactionRemark.editFlag == "1" ? '修改' : '创建'}</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a remarkId="${transactionRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a remarkId="${transactionRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveRemark" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tbody-transactionHistory">

						<c:forEach items="${transactionHistories}" var="transactionHistory">
						<tr>
							<td>${transactionHistory.stage}</td>
							<td>${transactionHistory.money}</td>
							<td>${transactionHistory.expectedDate}</td>
							<td>${transactionHistory.createTime}</td>
							<td>${transactionHistory.createBy}</td>
						</tr>
						</c:forEach>

					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>