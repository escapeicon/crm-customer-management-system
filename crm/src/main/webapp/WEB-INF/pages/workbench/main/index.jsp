<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%= base%>" />
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/echars/echarts.min.js"></script>

	<script type="text/javascript">
		$(function (){
			//发送ajax请求获取市场活动数据
			$.ajax({
				type:'post',
				url:'workbench/chart/activity/getActivityData.do',
				success(data){
					if (data != null) {
						data = data.map(item => [new Date(item.endDate).getMonth()+1,new Date(item.endDate).getDate()]);
						renderActivityCharts(data);
					}
				}
			})
			//发送ajax请求获取线索数据
			$.ajax({
				type:'post',
				url:'workbench/chart/clue/getClueData.do',
				success(data){
					if (data != null) {
						const xRay = data.map(item => item.name);
						renderClueCharts(xRay,data);
					}
				}
			})
			//发送ajax请求获取客户和联系人数据
			$.ajax({
				type:'post',
				url:'workbench/chart/customerAndContacts/getContactsData.do',
				success(data){
					if (data != null) {
						const xRay = data.map(item => item.name);
						renderCustomerAndContactCharts(xRay,data);
					}
				}
			})
			//发送ajax请求获取交易数据
			$.ajax({
				type:'post',
				url:'workbench/chart/transaction/getTransactionData.do',
				success(data){
					if (data != null) {
						renderTransactionCharts(data);
					}
				}
			})
		})

		/**
		 * 渲染市场活动图表
		 * @param data
		 */
		function renderActivityCharts(data){
			const chartDom = document.getElementById("activity");
			const myChart = echarts.init(chartDom);

			const option = {
				title:{
					text:"市场活动结束日期散点图"
				},
				xAxis: {
					name:'月份'
				},
				yAxis: {
					name:'日期'
				},
				series: [
					{
						symbolSize: 20,
						data: data,
						type: 'scatter'
					}
				]
			};
			option && myChart.setOption(option);
		}
		/**
		 * 渲染客户联系人图表
		 * @param xRay
		 * @param data
		 */
		function renderCustomerAndContactCharts(xRay,data){
			const chartDom = document.getElementById("customerAndContact");
			const myChart = echarts.init(chartDom);

			const option = {
				title: {
					text: '联系人客户统计图表'
				},
				toolbox: {
					feature: {
						dataView: { readOnly: false },
						restore: {},
						saveAsImage: {}
					}
				},
				tooltip: {
					trigger: 'axis',
					axisPointer: {
						type: 'shadow'
					}
				},
				xAxis: {
					type: 'category',
					data: xRay,
					axisTick: {
						alignWithLabel: true
					},
					axisLabel: {
						interval:0,//代表显示所有x轴标签显示
					}
				},
				yAxis: {
					type: 'value'
				},
				series: [
					{
						name:"Direct",
						type: 'bar',
						showBackground: true,
						backgroundStyle: {
							color: 'rgba(180, 180, 180, 0.2)'
						},
						data: data,
					}
				]
			};
			myChart.setOption(option);
		}
		/**
		 * 渲染交易图表
		 * @param data
		 */
		function renderTransactionCharts(data){
			const chartDom = document.getElementById("transaction");
			const myChart = echarts.init(chartDom);

			const option = {
				title: {
					text: '交易统计图表'
				},
				tooltip: {
					trigger: 'item',
					formatter: '{a} <br/>{b} : {c}'
				},
				toolbox: {
					feature: {
						dataView: { readOnly: false },
						restore: {},
						saveAsImage: {}
					}
				},
				legend: {
					data: data.stages
				},
				series: [
					{
						name: 'Expected',
						type: 'funnel',
						left: '10%',
						width: '80%',
						label: {
							formatter: '{b}Expected'
						},
						labelLine: {
							show: false
						},
						itemStyle: {
							opacity: 0.7
						},
						emphasis: {
							label: {
								position: 'inside',
								formatter: '{b}Expected: {c}%'
							}
						},
						data: data.chartObjs
					}
				]
			};
			option && myChart.setOption(option);
		}

	</script>
	<style type="text/css">
		#main{
			width: 100%;
			height: 100vh;
			display: grid;
			grid-template-columns: 1fr 1fr 1fr 1fr;
			grid-template-rows: 500px 400px;
			grid-row-gap:10px;
			grid-column-gap:10px;
		}
		#transaction{
			grid-area: 1/5/2/2;
		}
		#customerAndContact{
			grid-area: 2/-1/-1/1;
		}
		.chart{
		}
	</style>
</head>
<body>
	<%--<img src="image/home.png" style="position: relative;top: -10px; left: -10px;"/>--%>
	<div id="main">
		<div class="chart" id="transaction" ></div>
		<div class="chart" id="activity" ></div>
		<div class="chart" id="customerAndContact" ></div>
	</div>
</body>
</html>