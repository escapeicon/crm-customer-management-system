package com.mycode.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class HSSFUtils {
    private HSSFUtils(){}

    public static String getCellValueForString(HSSFCell cell){
        if(cell != null){
            int cellType = cell.getCellType();

            String res = "";
            if (cellType == HSSFCell.CELL_TYPE_STRING) {
                res = cell.getStringCellValue();
            }else if(cellType == HSSFCell.CELL_TYPE_NUMERIC){
                res = cell.getNumericCellValue() + "";
            }else if(cellType == HSSFCell.CELL_TYPE_BOOLEAN){
                res = cell.getBooleanCellValue() + "";
            }else if(cellType == HSSFCell.CELL_TYPE_FORMULA){
                res = cell.getCellFormula();
            }else{
                res = "";
            }
            return res;
        }

        return "";
    }
}
