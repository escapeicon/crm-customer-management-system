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
                url:'workbench/chart/clue/getClueData.do',
                success(data){
                    if (data != null) {
                        const xRay = data.map(item => item.name);
                        renderCharts(xRay,data);
                    }
                }
            })
        })

        /**
         * 渲染图表
         * @param xRay
         * @param data
         */
        function renderCharts(xRay,data){
            const chartDom = document.getElementById("main");
            const myChart = echarts.init(chartDom);

            const option = {
                title: {
                    text: '线索统计图表'
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
                    data: xRay
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
                        data: data
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