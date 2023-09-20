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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class GenerateExcelFile {

    /**
     * 私有化无参构造函数
     */
    private GenerateExcelFile(){}

    public static void generateFile(String sheetName, Class objClass, List targetList,String realPath) throws Exception {
        HSSFWorkbook workbook = new HSSFWorkbook();//生成excel文件
        HSSFCellStyle style = workbook.createCellStyle();//生成表格样式实体类
        style.setAlignment(HorizontalAlignment.CENTER);//设置字体居中
        style.setBorderTop(BorderStyle.MEDIUM);//设置上边框
        style.setBorderBottom(BorderStyle.MEDIUM);//设置下边框
        style.setBorderLeft(BorderStyle.MEDIUM);//设置左边框
        style.setBorderRight(BorderStyle.MEDIUM);//设置右边框
        HSSFSheet sheet = workbook.createSheet(sheetName);//生成一页

        HashMap<String, Integer> cellColIndex = new HashMap<String, Integer>();

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

        //生成表的内容部分
        for(int activityIndex = 1;activityIndex <= targetList.size();activityIndex++){
            Object target = targetList.get(activityIndex-1);//索引为-1的目的：正确索引到每个元素
            HSSFRow rowBody = sheet.createRow(activityIndex);//创建行
            try {
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
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        //写excel表格
        FileOutputStream os = new FileOutputStream(realPath);//创建输出流
        workbook.write(os);//写出文档

        os.flush();//推流
        os.close();//关闭流
    }

}
