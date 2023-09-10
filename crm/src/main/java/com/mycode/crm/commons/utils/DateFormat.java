package com.mycode.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormat {
    //私有化无参构造
    private DateFormat(){}

    /**
     * 格式：年-月-日 时:分:秒
     * @param date
     * @return
     */
    public static String formatDateTime(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return simpleDateFormat.format(date);
    }

    /**
     * 格式：年-月-日
     * @param date
     * @return
     */
    public static String formatDate(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDateFormat.format(date);
    }

    /**
     * 格式：时:分:秒
     * @param date
     * @return
     */
    public static String formatTime(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
        return simpleDateFormat.format(date);
    }
}
