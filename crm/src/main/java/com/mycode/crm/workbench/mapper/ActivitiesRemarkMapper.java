package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivitiesRemarkMapper {
    int deleteByPrimaryKey(String id);
    int insert(ActivityRemark record);
    int insertSelective(ActivityRemark record);
    ActivityRemark selectByPrimaryKey(String id);
    int updateByPrimaryKeySelective(ActivityRemark record);
    int updateByPrimaryKey(ActivityRemark record);

    /**
     * 添加市场活动备注
     * @param activityRemark
     * @return 添加条数
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 删除市场活动备注 根据id
     * @param id
     * @return 数据库记录更新条数
     */
    int deleteActivityRemarkById(String id);

    /**
     * 修改市场活动 根据id
     * @param activityRemark
     * @return 数据库更新条数
     */
    int updateActivityRemarkById(ActivityRemark activityRemark);

    /**
     * 查询该市场活动所有备注 通过市场活动id
     * @param id
     * @return 市场活动备注
     */
    List<ActivityRemark> selectActivityRemarkForDetailById(String id);
}