package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivitiesRemarkService {

    /**
     * 添加市场活动备注
     * @param activityRemark
     * @return 添加的条数
     */
    int saveActivityRemark(ActivityRemark activityRemark);

    /**
     * 删除市场活动备注 根据id
     * @param id
     * @return 删除的市场活动备注条数
     */
    int deleteActivityRemarkById(String id);

    /**
     * 修改市场活动备注 根据id
     * @param activityRemark 市场活动备注实体类
     * @return 修改条数
     */
    int modifyActivityRemarkById(ActivityRemark activityRemark);

    /**
     * 查询市场活动所有备注信息 通过市场活动id
     * @param id
     * @return 市场活动备注集合
     */
    List<ActivityRemark> queryActivityRemarkForDetailById(String id);
}
