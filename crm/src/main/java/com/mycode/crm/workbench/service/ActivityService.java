package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     * 创建市场活动
     * @return 数据库更新条数
     */
    int saveCreateActivity(Activity activity);

    /**
     * 根据分页数据查询指定市场活动数据
     * @param pageInfo
     * @return 市场活动list集合
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> pageInfo);

    /**
     * 查询分页查询的结果条数的总和
     * @param pageInfo
     * @return 结果条数的总和
     */
    int queryCountOfActivityByCondition(Map<String,Object> pageInfo);
}
