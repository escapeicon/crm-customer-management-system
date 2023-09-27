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
		const source = $("#source option:selected").text();
		const owner = $("#owner").val().trim();
		const mphone = $("#mphone").val().trim();
		const state = $("#state option:selected").text();

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
				const totalRows = data.totalRows;//总条数
				let clues = data.clues;//所有线索

				let html = "";

				clues.forEach(function (clue){
					html += "<tr>"
					html += "	<td><input type=\"checkbox\" value='"+clue.id+"' /></td>"
					html += "	<td><a style=\"text-decoration: none; cursor: pointer;\" >"+clue.fullname+"</a></td>"
					html += "	<td>"+clue.company+"</td>"
					html += "	<td>"+clue.phone+"</td>"
					html += "	<td>"+clue.mphone+"</td>"
					html += "	<td>"+clue.source+"</td>"
					html += "	<td>"+clue.createBy+"</td>"
					html += "	<td>"+clue.state+"</td>"
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
						queryForPage(currentPage,rowsPerPage);//刷新页面
					}
				})
			}
		})

	}

	/**
	 * 规则判断
	 */
	function judgeCreate(){
		//获取所有需要填入的输入框
		const companyValue = $("#create-company").val();
		const fullnameValue = $("#create-surname").val();
		const emailValue = $("#create-email").val();
		const phoneValue = $("#create-phone").val();
		const websiteValue = $("#create-website").val();
		const mphoneValue = $("#create-mphone").val();

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
		if(isFullnameAndCompany && isEmail && isPhone && isWebsite && isMphone){
			$("#save-create-clue").attr("disabled",false);
		}else{
			$("#save-create-clue").attr("disabled",true);
		}
	}

	//入口函数
	$(function(){
		//页面刷新完调用分页查询加载所有线索
		queryCluesForPage('${pageNo == null ? 1 : pageNo}','${pageSize == null ? 10 : pageSize}');

		//条件查询按钮
		$("#queryCluesByConditionForPage").click(function (){
			queryCluesForPage(1,$("#bs-pagination").bs_pagination("getOption","rowsPerPage"));
		})

		//弹出创建线索窗口
		$("#create-clue").click(function (){
			$("#save-create-clue").attr("disabled",true);//每次弹出创建线索窗口都禁用保存按钮
			$("#createClueModal").modal("show");//让模态窗口显现
			document.getElementById("createClurForm").reset();//重置创建线索模态窗口填入数据

			//重置判断规则
			let isFullnameAndCompany = false;//名称和公司是否通过验证
			let isEmail = true;//邮箱是否正确
			let isPhone = true;//座机号码是否正确
			let isWebsite = true;//公司网站是否正确
			let isMphone = true;//手机号是否正确
		})
		//创建线索事件
		$("#save-create-clue").click(function (){
			//获取所有需要填入的输入框
			const owner = $("#create-clueOwner").val();//所有者
			const company = $("#create-company").val();//公司
			const fullname = $("#create-surname").val();//姓名
			const appellation = $("#create-call").val();//称号
			const job = $("#create-job").val();//职位
			const email = $("#create-email").val();//邮箱
			const phone = $("#create-phone").val();//公司座机
			const website = $("#create-website").val();//公司网站
			const mphone = $("#create-mphone").val();//手机
			const state = $("#create-status").val();//线索状态
			const source = $("#create-status").val();//线索来源
			const description = $("#create-describe").val();//线索描述
			const contactSummary = $("#create-contactSummary").val();//联系纪要
			const nextContactTime = $("#create-nextContactTime").val();//下次联系时间
			const address = $("#create-address").val();//详细地址

			$.ajax({
				type:'post',
				url:'workbench/clue/createClue.do',
				dataType:'json',
				data:{
					owner:owner,
					company:company,
					fullname:fullname,
					appellation:appellation,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
				},
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

		//验证输入规则
		$("#create-company," +
				"#create-surname," +
				"#create-email," +
				"#create-phone," +
				"#create-website," +
				"#create-mphone").blur(judgeCreate)

		//日历组件
		$("#create-nextContactTime").datetimepicker({
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
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
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

						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>

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

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>广告</option>
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
								  <option>聊天</option>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

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
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

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
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
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

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="fullname" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="company" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="phone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="source" class="form-control">
					  	  <option></option>
					  	  <option>广告</option>
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
						  <option>聊天</option>
					  </select>
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="owner" class="form-control" type="text">
				    </div>
				  </div>



				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="mphone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="state" class="form-control">
					  	<option></option>
					  	<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>
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
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<%--展示数据区域--%>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
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
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">${clue.fullname}</a></td>
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
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
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