package com.mycode.crm.workbench;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Scanner;

public class ApachePoiTest {

    @Test
    public void testPoi() throws IOException {
        HSSFWorkbook workbook = new HSSFWorkbook();//生成excel文件

        HSSFCellStyle cellStyle = workbook.createCellStyle();//创建单元格样式实体类
        cellStyle.setAlignment(HorizontalAlignment.CENTER);//设置文字居中

        HSSFSheet sheet = workbook.createSheet("页面");//生成excel文件中的一页

        HSSFRow row = sheet.createRow(0);//生成第一行

        HSSFCell cell = row.createCell(0);//生成第一列
        cell.setCellValue("学号");//设置第一列的学号
        cell.setCellStyle(cellStyle);

        cell = row.createCell(1);
        cell.setCellValue("姓名");//设置第二列的姓名
        cell.setCellStyle(cellStyle);

        cell = row.createCell(2);
        cell.setCellValue("年龄");//设置第三列的年龄
        cell.setCellStyle(cellStyle);


        for (int i = 1;i <= 10;i++){
            HSSFRow studentInfoRow = sheet.createRow(i);

            HSSFCell studentInfoCell = studentInfoRow.createCell(0);
            studentInfoCell.setCellValue(100+i);
            studentInfoCell.setCellStyle(cellStyle);

            studentInfoCell = studentInfoRow.createCell(1);
            studentInfoCell.setCellValue("name"+i);
            studentInfoCell.setCellStyle(cellStyle);

            studentInfoCell = studentInfoRow.createCell(2);
            studentInfoCell.setCellValue(20 + i);
            studentInfoCell.setCellStyle(cellStyle);

        }

        FileOutputStream os = new FileOutputStream("D:\\studentList.xls");
        workbook.write(os);

        os.close();
        workbook.close();
    }

    @Test
    public void testTemp(){
        double money = 0;
        for(int day = 1;true;day++){
            money += 2.5;
            if(day % 5 == 0){
                money -= 6;
            }
            if(money >= 100){
                System.out.println(day);
                break;
            }
        }
    }
}
