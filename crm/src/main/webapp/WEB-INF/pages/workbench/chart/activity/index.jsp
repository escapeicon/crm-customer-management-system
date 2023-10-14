<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=base%>">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>交易统计图表</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echars/echarts.min.js"></script>
    <script type="text/javascript">

        $(function (){
            //发送ajax请求获取数据
            $.ajax({
                type:'post',
                url:'workbench/chart/activity/getActivityData.do',
                success(data){
                    if (data != null) {
                        data = data.map(item => [new Date(item.endDate).getMonth()+1,new Date(item.endDate).getDate()]);
                        renderCharts(data);
                    }
                }
            })
        })

        /**
         * 渲染图表
         * @param xRay
         * @param data
         */
        function renderCharts(data){
            const chartDom = document.getElementById("main");
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
    </script>
</head>
<body>
<div id="main" style="width: 1000px;height:600px;margin: 20px auto"></div>
</body>
</html>