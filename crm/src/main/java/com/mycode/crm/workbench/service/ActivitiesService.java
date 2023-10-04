package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivitiesService {
    /**
     * 创建市场活动
     * @return 数据库更新条数
     */
    int saveCreateActivity(Activity activity);
    /**
     * 以集合形式保存市场活动
     * @param activities
     * @return 影响数据库记录条数
     */
    int saveActivitiesByList(List<Activity> activities);

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

    /**
     * 根据id数组查询市场活动
     * @param ids
     * @return 查询市场活动结果
     */
    List<Activity> queryActivitiesByIds(String[] ids);

    /**
     * 根据市场活动id查询市场活动明细信息
     * @param id
     * @return 市场活动
     */
    Activity queryActivityByIdForDetail(String id);

    /**
     * 查询市场活动集合 for 线索页面 根据 线索id
     * @param clueId
     * @return 市场活动集合
     */
    List<Activity> queryActivitiesByClueIdForClueRemarkPage(String clueId);

    /**
     * 查询所有市场活动 for 线索页面 by 线索id exclude 已绑定的线索
     * @param clueId
     * @return 市场活动集合
     */
    List<Activity> queryAllActivitiesForClueRemarkPageByClueIdExcludeBundled(String clueId);
}
