package com.mycode.crm.commons.utils;

import com.mycode.crm.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

public class GenerateExcelFile {

    private HSSFWorkbook workbook;
    private HSSFSheet sheet;
    private HSSFCellStyle style;
    //Map集合装载表头信息和对应列数
    private Map<String,Integer> cellColIndex = new HashMap<String, Integer>();
    //被生成的类
    private Class objClass;

    //私有化无参构造
    private GenerateExcelFile(){}

    public GenerateExcelFile(String sheetName,Class objClass){
        this.workbook = new HSSFWorkbook();//生成excel文件
        this.sheet = workbook.createSheet(sheetName);//生成excel的一页
        this.style = workbook.createCellStyle();//生成样式文件
        this.objClass = objClass;
    }

    /**
     * 设置边框样式及文字居中
     */
    private void setStyle(){
        this.style.setAlignment(HorizontalAlignment.CENTER);//设置字体居中
        this.style.setBorderTop(BorderStyle.MEDIUM);//设置上边框
        this.style.setBorderBottom(BorderStyle.MEDIUM);//设置下边框
        this.style.setBorderLeft(BorderStyle.MEDIUM);//设置左边框
        this.style.setBorderRight(BorderStyle.MEDIUM);//设置右边框
    }

    /**
     * 生成表头
     */
    private void generateExcelHeader(){
        //生成表头
        HSSFRow rowHeader = sheet.createRow(0);//生成第一行
        Field[] fields = objClass.getDeclaredFields();//获取所有已定义的属性
        for(int fieldIndex = 0;fieldIndex < fields.length;fieldIndex++){
            Field field = fields[fieldIndex];
            String fieldName = field.getName();//获取属性名
            HSSFCell cell = rowHeader.createCell(fieldIndex);//创建单元格
            cell.setCellValue(fieldName);//设置单元格的值
            cell.setCellStyle(style);//应用样式
            cellColIndex.put(fieldName,cell.getColumnIndex());
        }
    }

    /**
     * 集合的excel生成方法
     * @param targetList
     * @return 一个excel文件对象
     * @throws Exception
     */
    public HSSFWorkbook generateFileForList( List targetList) throws Exception {
        setStyle();//设置样式
        this.generateExcelHeader();//生成表头
        for(int activityIndex = 1;activityIndex <= targetList.size();activityIndex++){
            Object target = targetList.get(activityIndex-1);//索引为-1的目的：正确索引到每个元素
            generateExcelBody(target,activityIndex);//生成表的内容部分
        }
        return this.workbook;
    }

    /**
     * 单个对象的excel生成方法
     * @param targetObj
     * @return excel文件对象
     */
    public HSSFWorkbook generateFileForObject(Object targetObj) throws Exception {
        setStyle();//设置样式
        this.generateExcelHeader();//生成表头
        this.generateExcelBody(targetObj,1);//生成表的内容部分
        return this.workbook;
    }

    /**
     * 生成表的内容
     * @param target 目标对象
     * @param activityIndex 行数，如果创建单个对象为1
     * @throws Exception
     */
    private void generateExcelBody(Object target,int activityIndex) throws Exception {
        HSSFRow rowBody = sheet.createRow(activityIndex);//创建行
        Class<?> aClass = target.getClass();//获取target实体类
        Method[] declaredMethods = aClass.getDeclaredMethods();//获取其所有方法
        int cellIndex = 0;
        for(Method method:declaredMethods){
            //获取get方法
            if ("get".equals(method.getName().substring(0,3))) {
                String fieldName = method.getName().substring(3).toLowerCase().substring(0,1) + method.getName().substring(4);
                String value = (String) method.invoke(target);//通过get方法获取target对象属性值
                if ("" != value) {
                    HSSFCell cell = rowBody.createCell(cellColIndex.get(fieldName));//获取单元格
                    cell.setCellValue(value);//设置单元格的值
                    cell.setCellStyle(style);//设置单元格的样式
                    //将获取的值存入excel表格中的单元格中
                    cellIndex++;
                }
            }
        }
    }
}
