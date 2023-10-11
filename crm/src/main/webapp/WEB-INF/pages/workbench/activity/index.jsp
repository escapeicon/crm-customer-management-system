<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%= base%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js" ></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	//获取所有者
	let owner = null;
	//获取名称
	let name = null;
	//获取成本
	let cost = null;
	//获取开始日期
	let startDate = null;
	//获取结束日期
	let endDate = null;

	//判断规则需要的类型
	let type = null;

	//设置主要选项是否解禁提交按钮的flag
	let isSubmitMain = false;
	//设置日期选项是否解禁提交按钮的flag
	let isSubmitDate = true;
	//设置成本选项是否解禁提交按钮的flag
	let isSubmitCost = true;

	let noEdit = true;//是否是编辑状态

	//设置pageSize
	let pageSize = 10;

	/**
	 * 条件查询方法
	 * @param pageNo
	 */
	function queryForPage(pageNo,pageSize){
		//重置判断条件
		isSubmitMain = false;
		isSubmitDate = true;
		isSubmitCost = true;
		noEdit = true;

		//获取查询的条件
		const queryName = $("#queryName").val();
		const queryOwner = $("#queryOwner").val();
		const queryStartDate = $("#queryStartDate").val();
		const queryEndDate = $("#queryEndDate").val();

		$("#checkAll").prop("checked",false);

		//加载页面顺便加载市场活动列表
		$.ajax({
			type: "post",
			url: "workbench/activity/queryActivityForPage.do",
			data: {
				name: queryName,
				owner: queryOwner,
				startDate: queryStartDate,
				endDate: queryEndDate,
				pageNo: pageNo,
				pageSize: pageSize
			},
			success(res) {
				if (res != null) {
					const totalRows = res.totalRows;//获取总数
					const activityList = res.activityList;//获取查询到的所有数据

					if (activityList.length == 0 && totalRows != 0) {
						queryForPage(pageNo - 1,pageSize);
					}else {
						$("#allResultB").text(totalRows);//修改总条数显示内容

						$("#tBody").empty();//删除所有子元素，刷新市场活动列表

						//拼接HTML代码
						$(activityList).each(function (index,item){
							const statement = '' +
									'<tr class="active">'+
									'<td><input type="checkbox" value="'+item.id+'"/></td>'+
									'<td><a activityId="'+item.id+'" style="text-decoration: none; cursor: pointer;">'+item.name + '</a></td>'+
									'<td>' + item.owner + '</td>'+
									'<td>' + item.startDate + '</td>'+
									'<td>' + item.endDate + '</td>'+
									'</tr>';

							$("#tBody").append(statement);
						})

						//切换页数的时候刷新市场活动列表时取消全选按钮
						$("#checkAll").prop("checked",false);

						//计算总页数
						let totalPages = 1;
						if (totalRows % pageSize == 0) {
							totalPages = totalRows / pageSize;
						}else {
							totalPages = parseInt((totalRows / pageSize) + 1);
						}

						//分页插件
						$("#demo_pag1").bs_pagination({
							currentPage: pageNo,//当前页面
							rowsPerPage: pageSize,//每页显示条数
							totalRows:totalRows,//总条数
							totalPages: totalPages,//总页数，必填参数

							showGoToPage: true,//展示跳转页面组件
							showRowsPerPage: true,//是否显示“每页显示条数”部分
							showRowsInfo:true,//是否显示记录的信息

							visiblePageLinks: 10,//可视的页面连接数
							onChangePage:function (event,data){
								const currentPage = data.currentPage;//获取当前页面
								const rowsPerPage = data.rowsPerPage;//获取每页显示条数
								queryForPage(currentPage,rowsPerPage);//刷新页面
							}
						});
					}
				}
			}
		})
	}

	//入口函数
	$(function(){
		queryForPage('${activityPageNo == null ? 1 : activityPageNo}','${activityPageSize == null ? 10 : activityPageSize}');//加载页面顺便加载市场活动列表

		//-------------------------------------------------------

		/**
		 * 查询市场活动备注点击事件
		 */
		$("#tBody").on("click",".active td a",function (){
			const activityId = $(this).attr("activityId");//获取id

			window.location.href="workbench/activity/detailActivity.do?id=" + activityId;
		})


		//----------------------添加输入框规则判断-------------------

		/**
		 * 对所有者和姓名进行规则判断
		 * 所有者和姓名必填
		 */
		$("#create-marketActivityOwner,#create-marketActivityName,#edit-marketActivityOwner,#edit-marketActivityName").blur(function (){

			//获取所有者
			owner = $("#"+type+"-marketActivityOwner").val();
			//获取名称
			name = $.trim($("#"+type+"-marketActivityName").val());

			if (owner != "" && name != "") {
				isSubmitMain = true;
			}else {
				//封禁保存按钮
				isSubmitMain = false;
			}
			judgeAll();
		})

		/**
		 * 对成本进行规则判断
		 * 成本只能为非负整数
		 */
		$("#create-cost,#edit-cost").blur(function (){

			cost = $.trim($("#"+type+"-cost").val());
			//正则匹配非负整数
			if (!/^[+]?\d*$/.test(cost)){
				alert("成本必须为非负整数!");
				isSubmitCost = false;
			}else {
				isSubmitCost = true;
			}
			judgeAll();
		})

		/**
		 * 判断日期是否符合规则的方法
		 */
		function judgeDate(){

			startDate = $("#"+type+"-startTime").val();
			endDate = $("#"+type+"-endTime").val();

			//判断是否为空字符串
			if (startDate != "" && endDate != ""){
				//判断开始日期是否比截至日期大
				if (startDate >= endDate) {
					//弹出警告框且锁定保存键
					alert("开始日期不能超过截止日期!");
					isSubmitDate = false;
				}else {
					isSubmitDate = true;
				}
			}else {
				isSubmitDate = true;
			}
			judgeAll();
		}

		/**
		 * 规则判断函数
		 */
		function judgeAll(){
			//最后判断所有选项是否都输入合法
			if (isSubmitMain && isSubmitDate && isSubmitCost && noEdit) {
				$("#"+type+"-preserve").removeAttr("disabled");
			}else {
				$("#"+type+"-preserve").attr("disabled",true);
			}
		}

		/**
		 * 生成js日历
		 */
		$("#create-startTime,#create-endTime,#edit-startTime,#edit-endTime,#queryStartDate,#queryEndDate").datetimepicker({
			format:"yyyy-mm-dd",//日期格式
			language:"zh-CN",//语言
			minView:'month',
			initialDate:new Date(),//初始化时显示当前日期
			autoclose:true,//设置选择完日期或时间之后，是否自动关闭日历
			clearBtn:true,//设置是否显示清空按钮，默认为false
			todayBtn:true//设置是否显示今日按钮
		})
				.on('changeDate', function (e) {

			// 添加日期判断逻辑
			judgeDate();
		});

		//----------------------------添加------------------------

		/**
		 * 手动跳出创建市场活动页面
		 */
		$("#create-btn").click(function (){
			//清空表单信息
			document.getElementsByClassName("form-horizontal")[0].reset();

			//获取当前需要判断的方法类型：create or edit
			type = this.id.split("-")[0];

			//显示创建市场活动模态窗口
			$("#createActivityModal").modal("show");
		})

		/**
		 * 创建活动市场点击事件
		 */
		$("#create-preserve").click(function (){
			//获取描述
			let description = $.trim($("#create-describe").val());

			//发送ajax请求
			$.ajax({
				type:"post",
				url:"workbench/activity/saveCreateActivity.do",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description,
				},
				success(res){
					const code = res.code;//获取响应状态码
					if (code == "1") {
						//成功创建
						$("#createActivityModal").modal("hide");
						//刷新市场活动列表
						queryForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						//创建失败
						const message = res.message;//获取失败响应消息
						$("#createActivityModal").modal("show");
						alert(message);
					}
				}
			})
		})

		//---------------------------查询--------------------------------

		/**
		 * 查询市场活动函数
		 */
		$("#querySubmit").click(function (){
			queryForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
		})

		//-------------------------复选框--------------------------------

		/**
		 * 绑定全选复选框点击事件
		 */
		$("#checkAll").click(function (){
			//实现全选
			$("#tBody input[type='checkbox']").prop("checked",this.checked);
		})

		/**
		 * 绑定所有复选框点击事件
		 */
		$("tbody").on("click","input[type='checkbox']",function (){
			//根据选中的单选框的数量判断是否全部选中
			if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()) {
				$("#checkAll").prop("checked",true);
			}else{
				$("#checkAll").prop("checked",false);
			}
		})

		//------------------------删除---------------------------------

		/**
		 * 绑定删除按钮删除事件
		 */
		$("#deleteBtn").click(function (){
			let deleteTarArr = $("#tBody input[type='checkbox']:checked");
			//判断用户是否选择目标
			if (deleteTarArr.size() === 0) {
				alert("请选择要删除的市场活动");
				return;
			}

			const isDelete = window.confirm("是否确认删除");//弹出确认删除弹框
			//确认删除
			if (isDelete) {
				let ids = "";
				//获取选中的市场活动id
				deleteTarArr.each(function (){
					ids += "id="+this.value+"&";
				})
				ids = ids.substring(0,ids.length-1);

				//发送ajax请求
				$.ajax({
					type:'post',
					url:'workbench/activity/deleteActivityById.do',
					data:ids,
					dataType:'json',
					success(response){
						if (response.code == "1") {
							queryForPage(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
						}else{
							alert(response.message);
						}
					}
				})

			}
		})

		//-----------------------修改----------------------------------

		/**
		 * 对是否修改进行简单判断
		 */
		$("#edit-form-horizontal input,select,textarea").change(function (){
			noEdit = true;
		})

		/**
		 * 绑定修改按钮修改事件
		 */
		$("#edit-btn").click(function (){
			//获取选中的checkbox
			let checkedBoxs = $("#tBody input[type='checkbox']:checked");

			//获取当前需要判断的方法类型：create or edit
			type = this.id.split("-")[0];

			//---为提升判断的体验提前设置owner和name为符合规则的
			isSubmitMain = true;

			noEdit = false;//进入编辑状态

			//清空表单信息
			document.getElementsByClassName("form-horizontal")[1].reset();
			judgeAll();//先进行一遍检测

			//验证选中的checkbox是否符合规则
			if (checkedBoxs.size() !== 1) {
				alert("请至少选择1个市场活动进行修改!");
			}else {
				//获取checkbox中的value
				const id = checkedBoxs.val();

				//发送ajax请求获取该市场活动的信息
				$.ajax({
					type:'post',
					url:'workbench/activity/queryActivityById.do',
					data:{
						id:id
					},
					success(response){
						//修改页面显示数据
						$("#edit-id").val(response.id);
						$("#edit-marketActivityOwner").val(response.owner);
						$("#edit-marketActivityName").val(response.name);
						$("#edit-startTime").val(response.startDate);
						$("#edit-endTime").val(response.endDate);
						$("#edit-cost").val(response.cost);
						$("#edit-describe").val(response.description);

						//弹出模态窗口
						$("#editActivityModal").modal("show");
					}
				})
			}
		})

		/**
		 * 修改活动市场点击事件
		 */
		$("#edit-preserve").click(function (){
			let description = $.trim($("#edit-describe").val());

			$.ajax({
				type:'post',
				url:'workbench/activity/modifyActivityById.do',
				data:{
					id:$("#edit-id").val(),
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description,
				},
				success(response){
					if (response.code !== "1") {
						console.log(1)
						//弹出警告框
						alert(response.message);
					}else{
						//清空tupe，为下次使用type做准备
						type = null;
						//关闭修改模态窗口
						$("#editActivityModal").modal("hide");
						//清空表单信息
						document.getElementsByClassName("form-horizontal")[1].reset();
						//刷新页面
						queryForPage(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					}
				}
			})
		})

		/**
		 * 批量导出市场活动
		 */
		$("#exportActivityAllBtn").click(function (){
			window.location.href = "workbench/activity/downloadAllActivities.do";
		})

		/**
		 * 选择导出
		 */
		/*$("#exportActivityXzBtn").click(function (){
			const checkedActivity = $("#tBody input[type='checkbox']:checked");//获取用户选择的市场活动

			if (checkedActivity.size() <= 0) {
				alert("请至少选择一条市场活动进行导出!");
				return;
			}

			//获取id
			let ids = "";
			checkedActivity.each(function (){
				ids += "id="+$(this).val()+"&";
			})
            ids = ids.substring(0,ids.length-1);

            window.location.href = "workbench/activity/downloadSingleActivity.do?"+ids;
		})*/
		$("#exportActivityXzBtn").click(function (){
			const checkedActivity = $("#tBody input[type='checkbox']:checked"); // 获取用户选择的市场活动

			if (checkedActivity.size() <= 0) {
				alert("请至少选择一条市场活动进行导出!");
				return;
			}

			// 获取id
			let ids = [];
			checkedActivity.each(function (){
				ids.push($(this).val());
			});

			// 发送 POST 请求
			const xhr = new XMLHttpRequest();
			xhr.open("POST", "workbench/activity/downloadSingleActivity.do");
			xhr.setRequestHeader("Content-Type", "application/json");
			xhr.send(JSON.stringify(ids));
			xhr.responseType = "blob";

			xhr.onload = function () {
				if (xhr.status === 200) {
					const blob = xhr.response;
					const a = document.createElement("a");
					a.href = window.URL.createObjectURL(blob);
					a.download = "exported_activity.xls";
					document.body.appendChild(a);
					a.style.display = "none";
					a.click();
					document.body.removeChild(a);
				} else {
					alert("导出失败，请重试！");
				}
			};
		});

		/**
		 * 批量导入市场活动
		 */
		$("#importActivityBtn").click(function (){
			//获取提交的文件名
			let filename = $("#activityFile").val();
			//获取附件信息
			const activitiesFile = $("#activityFile")[0].files[0];

			//进行规则验证
			let suffix = filename.substring(filename.lastIndexOf(".") + 1);//获取文件后缀名
			//判断文件后缀名是否为xls
			if (suffix !== "xls") {
				alert("格式错误，请上传xls的excel表格!");
			}
			//判断文件大小是否超过5mb
			if (activitiesFile.size > 1024 * 1024 * 5) {
				alert("文件过大，请把文件大小限制在5mb以内!");
			}

			//创建formdata对象，因为普通请求只会以字符串类型进行传输
			const formData = new FormData();
			formData.set("activitiesFile",activitiesFile);//通过formdata传输二进制数据

			//发送ajax请求
			$.ajax({
				type:'post',
				url:'workbench/activity/uploadActivities.do',
				processData:false,//设置在提交参数前，是否将所有参数统一转换为字符串，默认true
				contentType:false,//设置在提交参数前，是否将所有参数统一编码为urlEncoded，默认true
				data:formData,
				success(data){
					if (data.code === "1") {
						alert("成功导入" + data.data + "条数据");
						$("#importActivityModal").modal("hide");
						queryForPage(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					}else{
						alert(data.message);
					}
				}
			})
		})
	});

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
									<c:forEach var="user" items="${users}" >
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-startTime" autocomplete="off" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-endTime" autocomplete="off" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="create-preserve" type="button" class="btn btn-primary" disabled>保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="edit-form-horizontal" class="form-horizontal" role="form">

						<div class="form-group">
							<input type="hidden" id="edit-id" />
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
									<c:forEach var="user" items="${users}" >
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input readonly type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input readonly type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="edit-preserve" disabled>更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="queryName" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="queryOwner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input id="queryStartDate" class="form-control" type="text" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input id="queryEndDate" class="form-control" type="text" readonly>
				    </div>
				  </div>

				  <button id="querySubmit" type="button" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="create-btn" type="button" class="btn btn-primary" data-toggle="modal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="edit-btn" type="button" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="allResultB">50</b>条记录</button>
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
				</div>--%>
			</div>

		</div>

	</div>
</body>
</html>