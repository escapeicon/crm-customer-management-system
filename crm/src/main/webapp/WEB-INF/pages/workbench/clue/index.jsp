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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	let isFullnameAndCompany = false;//名称和公司是否通过验证
	let isEmail = true;//邮箱是否正确
	let isPhone = true;//座机号码是否正确
	let isWebsite = true;//公司网站是否正确
	let isMphone = true;//手机号是否正确
	let isUpdateForClueJudge = true;//是否是修改线索的操作标志

	/**
	 * 分页查询方法
	 * @param pageNo
	 * @param pageSize
	 */
	function queryCluesForPage (pageNo,pageSize){
		//获取分页查询参数
		const fullname = $("#fullname").val().trim();
		const company = $("#company").val().trim();
		const phone = $("#phone").val().trim();
		const source = $("#source").val();
		const owner = $("#owner").val().trim();
		const mphone = $("#mphone").val().trim();
		const state = $("#state").val();

		//发送ajax请求
		$.ajax({
			type:'post',
			url:'workbench/clue/queryCluesForPageAndForCondition.do',
			data:{
				fullname:fullname,
				company:company,
				phone:phone,
				source:source,
				owner:owner,
				mphone:mphone,
				state:state,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success(data){
				if (data != null) {
					const totalRows = data.totalRows;//总条数
					let clues = data.clues;//所有线索

					//如果该页面条数为0则跳回前页
					if (clues.length == 0 && totalRows != 0) {
						queryCluesForPage(pageNo - 1,pageSize);
					}else {
						let html = "";

						clues.forEach(function (clue){
							html += "<tr>"
							html += "	<td><input type=\"checkbox\" value='"+clue.id+"' /></td>"
							html += "	<td><a clueId='"+clue.id+"' style=\"text-decoration: none; cursor: pointer;\" >"+clue.fullname+(clue.appellation == null ? '' : clue.appellation)+"</a></td>"
							html += "	<td>"+clue.company+"</td>"
							html += "	<td>"+clue.phone+"</td>"
							html += "	<td>"+clue.mphone+"</td>"
							html += "	<td>"+(clue.source == null ? '' : clue.source)+"</td>"
							html += "	<td>"+clue.owner+"</td>"
							html += "	<td>"+(clue.state == null ? '' : clue.state)+"</td>"
							html += "</tr>"
						})
						$("#tBody").html(html);

						//分页组件参数设置
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
								queryCluesForPage(currentPage,rowsPerPage);//刷新页面
							}
						})
					}
				}
			}
		})

	}

	/**
	 * 规则判断
	 */
	function judgeCreateAndUpdate(type){
		//获取所有需要填入的输入框
		const companyValue = $("#"+type+"-company").val();
		const fullnameValue = $("#"+type+"-surname").val();
		const emailValue = $("#"+type+"-email").val();
		const phoneValue = $("#"+type+"-phone").val();
		const websiteValue = $("#"+type+"-website").val();
		const mphoneValue = $("#"+type+"-mphone").val();

		//必须输入名称和公司
		if(companyValue != '' && fullnameValue != ''){
			isFullnameAndCompany = true;
		}else{
			isFullnameAndCompany = false;
		}

		//验证邮箱:邮箱不为空的情况下必须符合规则
		if(emailValue != ""){
			isEmail = false;
			if(/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(emailValue)){
				isEmail = true;
			}
		} else {
			isEmail = true;
		}

		//验证座机号码
		if(phoneValue != ""){
			isPhone = false;
			if(/^(\d{3,4}-)?\d{7,8}$/.test(phoneValue)){
				isPhone = true;
			}
		}else{
			isPhone = true;
		}

		//验证公司网站
		if(websiteValue != ""){
			isWebsite = false;
			if(/^http([s]?):\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/.test(websiteValue)){
				isWebsite = true;
			}
		} else {
			isWebsite = true;
		}

		//验证手机号
		if(mphoneValue != ""){
			isMphone = false;
			if(/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(mphoneValue)){
				isMphone = true;
			}
		}else{
			isMphone = true;
		}

		//对保存按钮是否禁用进行总体的验证
		if(isFullnameAndCompany && isEmail && isPhone && isWebsite && isMphone && isUpdateForClueJudge){
			$("#save-"+type+"-clue").attr("disabled",false);
		}else{
			$("#save-"+type+"-clue").attr("disabled",true);
		}
	}

	/**
	 * 获取创建或修改时输入框参数的值
	 * @param methodType
	 * @returns {{owner: (*|jQuery), website: (*|jQuery), address: (*|jQuery), description: (*|jQuery), source: (*|jQuery), nextContactTime: (*|jQuery), phone: (*|jQuery), company: (*|jQuery), mphone: (*|jQuery), fullname: (*|jQuery), appellation: (*|jQuery), state: (*|jQuery), contactSummary: (*|jQuery), job: (*|jQuery), email: (*|jQuery)}}
	 */
	function getInputVal(methodType){
		return {
			//获取所有需要填入的输入框
			id:$("#"+methodType+"-id").val(),//id
			owner: $("#"+methodType+"-clueOwner").val(),//所有者
			company: $("#"+methodType+"-company").val(),//公司
			fullname: $("#"+methodType+"-surname").val(),//姓名
			appellation: $("#"+methodType+"-appellation").val(),//称号
			job: $("#"+methodType+"-job").val(),//职位
			email: $("#"+methodType+"-email").val(),//邮箱
			phone: $("#"+methodType+"-phone").val(),//公司座机
			website: $("#"+methodType+"-website").val(),//公司网站
			mphone: $("#"+methodType+"-mphone").val(),//手机
			state: $("#"+methodType+"-status").val(),//线索状态
			source: $("#"+methodType+"-source").val(),//线索来源
			description: $("#"+methodType+"-describe").val(),//线索描述
			contactSummary: $("#"+methodType+"-contactSummary").val(),//联系纪要
			nextContactTime: $("#"+methodType+"-nextContactTime").val(),//下次联系时间
			address: $("#"+methodType+"-address").val(),//详细地址
		}
	}

	//入口函数
	$(function(){
		//页面刷新完调用分页查询加载所有线索
		queryCluesForPage('${cluePageNo == null ? 1 : cluePageNo}','${cluePageSize == null ? 10 : cluePageSize}');

		//条件查询按钮
		$("#queryCluesByConditionForPage").click(function (){
			queryCluesForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
		})

		//弹出创建线索窗口
		$("#create-clue").click(function (){
			$("#save-create-clue").attr("disabled",true);//每次弹出创建线索窗口都禁用保存按钮
			$("#createClueModal").modal("show");//让模态窗口显现
			document.getElementById("createClurForm").reset();//重置创建线索模态窗口填入数据

			isUpdateForClueJudge = true;//对修改标志放行
		})
		//创建线索事件
		$("#save-create-clue").click(function (){
			$.ajax({
				type:'post',
				url:'workbench/clue/createClue.do',
				dataType:'json',
				data:getInputVal("create"),
				success(data) {
					if (data.code) {
						$("#createClueModal").modal("hide");//让模态窗口消失
						queryCluesForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));//重新查询线索
					}else{
						alert(data.message);
					}
				}
			})

		})

		//按钮全选与反选
		$("#allCheckBox").change(function (){
			//获取所有线索的check标签
			$("#tBody input[type='checkbox']").prop("checked",$(this).prop("checked"))
		})
		//选中按钮达到每页显示条数时全选按钮状态改为选中
		$("#tBody").on("click","input[type='checkbox']",function (){
			$("#allCheckBox").prop("checked",$("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size())
		})

		//删除线索
		$("#delete-clue").click(function (){
			let ids = [];
			$("#tBody input[type='checkbox']:checked").each(function (){
				ids.push($(this).val())
			})

			//发送ajax请求
			$.ajax({
				type:'post',
				url:'workbench/clue/deleteClue.do',
				contentType:'application/json',
				data:JSON.stringify(ids),
				success(data){
					if (data.code) {
						queryCluesForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
					}else{
						alert(data.message)
					}
				}
			})
		})

		//修改线索
		$("#update-clue").click(function (){
			//只允许选中一条线索进行修改
			if ($("#tBody input[type='checkbox']:checked").size() == 1) {
				isUpdateForClueJudge = false;//对修改标志进行拦截
				$("#editClueModal").modal("show");//显示修改模态窗口
				const id = $("#tBody input[type='checkbox']:checked").val();//获取该条线索的id
				$.ajax({
					type:'post',
					url:'workbench/clue/toUpdateModal.do',
					data:{
						id:id
					},
					success(data){
						//渲染页面
						$("#edit-id").val(data.id);//id
						$("#edit-clueOwner").val(data.owner);//所属
						$("#edit-company").val(data.company);//公司
						$("#edit-appellation").val(data.appellation);//称呼
						$("#edit-surname").val(data.fullname);//姓名
						$("#edit-job").val(data.job);//职位
						$("#edit-email").val(data.email);//邮箱
						$("#edit-phone").val(data.phone);//座机
						$("#edit-website").val(data.website);//网站
						$("#edit-mphone").val(data.mphone);//手机
						$("#edit-status").val(data.state);//状态
						$("#edit-source").val(data.source);//线索来源
						$("#edit-describe").val(data.description);//描述
						$("#edit-contactSummary").val(data.contactSummary);//联系纪要
						$("#edit-nextContactTime").val(data.nextContactTime);//下次联系时间
						$("#edit-address").val(data.address);//详细地址
					}
				})
			}else{
				alert("请选择一条线索进行修改!");
			}
		})
		$("#save-edit-clue").click(function (){
			$.ajax({
				type:'post',
				url:'workbench/clue/saveUpdateClue.do',
				data:getInputVal("edit"),
				success(data){
					if (data.code) {
						$("#editClueModal").modal("hide");//隐藏修改模态窗口
						queryCluesForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));//刷新线索列表
					}else{
						alert(data.message)
					}
				}
			})
		})

		//验证输入规则
		$("#create-company,#create-surname,#create-email,#create-phone,#create-website,#create-mphone").blur(function (){
			judgeCreateAndUpdate("create");
		})
		$("#editClueModal select,#editClueModal input,#editClueModal textarea").blur(function (){
			isUpdateForClueJudge = true;//对修改按钮进行放行
			judgeCreateAndUpdate("edit");
		})

		//查看线索明细
		$("#tBody").on("click","a",function (){
			window.location.href = "workbench/clue/toClueRemark.do?clueId="+$(this).attr("clueId");
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
		})
	});

</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content" id="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClurForm" class="form-horizontal" role="form">

						<%--所有者 公司--%>
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								<c:forEach items="${users}" var="user">
									<option value="${user.id}">${user.name}</option>
								</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>

						<%--称号 姓名--%>
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellations}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>

						<%--职位 邮箱--%>
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<%--公司网站 座机--%>
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>

						<%--手机 线索状态--%>
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
								<c:forEach items="${clueStates}" var="clueState">
									<option value="${clueState.id}">${clueState.value}</option>
								</c:forEach>
								</select>
							</div>
						</div>

						<%--线索来源--%>
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sources}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<%--线索描述--%>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<%--联系纪要 下次联系时间--%>
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

						<%--详细地址--%>
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
					<button id="save-create-clue" type="button" class="btn btn-primary" disabled>保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">

						<%--clueOwner company--%>
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								  <c:forEach items="${users}" var="user">
									<option value="${user.id}">${user.name}</option>
								</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>

						<%--appellation surname--%>
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellations}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>

						<%--job email--%>
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>

						<%--phone website--%>
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>

						<%--mphone status--%>
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
								  <%--<option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
<c:forEach items="${clueStates}" var="status">
<option value="${status.id}">${status.value}</option>
</c:forEach>
								</select>
							</div>
						</div>

						<%--source--%>
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <%--<option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>--%>
<c:forEach items="${sources}" var="source">
<option value="${source.id}">${source.value}</option>
</c:forEach>
								</select>
							</div>
						</div>

						<%--describe--%>
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<%--contactSummary nextContactTime--%>
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01" readonly>
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<%--address--%>
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
					<button id="save-edit-clue" type="button" class="btn btn-primary" disabled>更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<%--分页查询--%>
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

					<%--fullname--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="fullname" class="form-control" type="text">
				    </div>
				  </div>

						<%--company--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="company" class="form-control" type="text">
				    </div>
				  </div>

						<%--phone--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="phone" class="form-control" type="text">
				    </div>
				  </div>

						<%--source--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="source" class="form-control">
					  	  <option></option>
					  	  <%--<option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>--%>
					  <c:forEach items="${sources}" var="source">
						<option value="${source.id}">${source.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <br>

						<%--owner--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="owner" class="form-control" type="text">
				    </div>
				  </div>

						<%--mphone--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="mphone" class="form-control" type="text">
				    </div>
				  </div>

						<%--state--%>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="state" class="form-control">
					  	<option></option>
						<c:forEach items="${clueStates}" var="state">
						<option value="${state.id}">${state.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="queryCluesByConditionForPage" type="button" class="btn btn-default">查询</button>

				</form>
			</div>
			<%--创建删除控制标签--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="create-clue" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="update-clue" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="delete-clue" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<%--展示数据区域--%>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allCheckBox" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
					<%--<c:forEach items="${clues}" var="clue">
						<tr>
							<td><input type="checkbox" value="${clue.id}"/></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">${clue.fullname}</a></td>
							<td>${clue.company}</td>
							<td>${clue.mphone}</td>
							<td>${clue.phone}</td>
							<td>${clue.source}</td>
							<td>${clue.createBy}</td>
							<td>${clue.state}</td>
						</tr>
					</c:forEach>--%>
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
				<%--分页组件区域--%>
				<div id="bs-pagination"></div>
			</div>


		</div>
		
	</div>
</body>
</html>