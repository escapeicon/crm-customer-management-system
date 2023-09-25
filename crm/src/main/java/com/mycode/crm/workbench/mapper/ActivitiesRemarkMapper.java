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
     * 通过市场活动id获取该市场活动所有备注
     * @param id
     * @return 市场活动备注
     */
    List<ActivityRemark> selectActivityRemarkForDetailById(String id);

    /**
     * 添加市场活动备注
     * @param activityRemark
     * @return 添加条数
     */
    int insertActivityRemark(ActivityRemark activityRemark);
}