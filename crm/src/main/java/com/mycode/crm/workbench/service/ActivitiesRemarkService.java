package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivitiesRemarkService {
    /**
     * 通过市场活动id查询市场活动所有备注信息
     * @param id
     * @return 市场活动备注集合
     */
    List<ActivityRemark> queryActivityRemarkForDetailById(String id);
}
