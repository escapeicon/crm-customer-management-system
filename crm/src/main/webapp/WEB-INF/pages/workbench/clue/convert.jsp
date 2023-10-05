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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	//查询到的所有市场活动
	let activities = null;

	/**
	 * 渲染 市场活动源模态窗口 市场活动源方法
	 * @param activities 市场活动数组
	 */
	function renderActivitiesList(activities){

		const preActivityId = $("#activity").attr("activityId");//获取当前选中的市场活动

		//拼接字符串
		let html = "";

		activities.forEach(item => {
			html += "<tr>"
			html += "	<td><input activityName='"+item.name+"' value='"+item.id+"' type=\"radio\" name=\"activity\" "+ (item.id == preActivityId ? "checked" : "") +"/></td>"
			html += "	<td>"+item.name+"</td>"
			html += "	<td>"+item.startDate+"</td>"
			html += "	<td>"+item.endDate+"</td>"
			html += "	<td>"+item.owner+"</td>"
			html += "</tr>"
		})

		//渲染市场活动搜索模态窗口 市场活动源数据
		$("#tbody-searchActivityModal").html(html);
	}

	$(function(){
		//展开创建交易标签
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//查询市场活动源
		$("#activity-source").click(function (){

			$("#search-activity-fuzzy-input").val("");//清空搜索栏

			$.ajax({
				type:'post',
				url:'workbench/clue/convertQueryActivity.do',
				data:{
					clueId:'${clue.id}'
				},
				success(data){
					if (data.code) {
						activities = data.data;//保存查询到的所有市场活动
						renderActivitiesList(activities);//渲染市场活动源 市场活动列表
						$("#searchActivityModal").modal("show");//显示市场活动源模态窗口
					}else {
						alert(data.message)
					}
				}
			})
		})
		//模糊查询市场活动名称
		$("#search-activity-fuzzy-input").keyup(function (){
			const inputVal = $(this).val().trim();//用户输入的值
			const newActivities = activities.filter(item => item.name.includes(inputVal));//模糊匹配市场活动源
			renderActivitiesList(newActivities);//渲染市场活动源列表
		})
		//用户点击市场活动单选按钮
		$("#tbody-searchActivityModal").on("click","input[name='activity']",function (){
			const activityId = $(this).val();//获取市场活动id
			const activityName = $(this).attr("activityName");//预创建市场活动对象

			$("#activity").val(activityName).attr("activityId",activityId);
			$("#searchActivityModal").modal("hide");
		})

		//线索转换
		$("#convert-clue-btn").click(function (){
			const clueId = '${clue.id}';
			//获取用户输入的数据
			const money = $("#amountOfMoney").val();
			const name = $("#tradeName").val();
			const expectedDate = $("#expectedClosingDate").val();
			const stage = $("#stage").val();
			const source = $("#activity").attr("activityId");
			const isCreateTran = $("#isCreateTransaction").prop("checked");

			$.ajax({
				type:'post',
				url:'workbench/clue/convertClue.do',
				data:{
					clueId:clueId,
					money:money,
					name:name,
					expectedDate:expectedDate,
					stage:stage,
					source:source,
					isCreateTran:isCreateTran
				},
				success(data) {
					if (data.code) {
						window.location.href = "workbench/clue/index.do";
					}else {
						alert(data.message);
					}
				}
			})

		})

		//返回线索页面按钮
		$("#cancel-btn").click(function (){
			window.location.href = "workbench/clue/index.do";
		})

		//日历组件
		$("#expectedClosingDate").datetimepicker({
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

	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-activity-fuzzy-input" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tbody-searchActivityModal">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}${clue.company == null ? '' : '-'}${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<%--新建联系人--%>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<%--为客户创建交易--%>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>

	<%--创建交易--%>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<form>
		<%--amountOfMoney--%>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
			<%--tradeName--%>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
		  </div>
			<%--expectedClosingDate--%>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate" readonly>
		  </div>
			<%--stage--%>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${stages}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
			<%--activity--%>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activity-source" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input activityId="" type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>

	</div>

	<%--记录的所有者--%>
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>

	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convert-clue-btn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input id="cancel-btn" class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>