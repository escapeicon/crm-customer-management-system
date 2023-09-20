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
     * 根据id修改市场活动信息
     * @param activity 市场活动实体类
     * @return 更新条数
     */
    int saveEditActivity(Activity activity);

    /**
     * 根据id删除市场活动
     * @param ids 市场活动id
     * @return 删除条数
     */
    int deleteActivityByIds(String[] ids);

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

    /**
     * 根据id查询指定市场活动
     * @param id
     * @return 市场活动信息
     */
    Activity queryActivityById(String id);

    /**
     * 获取所有市场活动
     * @return 市场活动集合
     */
    List<Activity> queryAllActivities();
}
