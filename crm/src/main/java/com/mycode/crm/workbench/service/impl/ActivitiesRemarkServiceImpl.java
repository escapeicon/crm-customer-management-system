package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.ActivityRemark;
import com.mycode.crm.workbench.mapper.ActivitiesRemarkMapper;
import com.mycode.crm.workbench.service.ActivitiesRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("activitiesRemarkService")
public class ActivitiesRemarkServiceImpl implements ActivitiesRemarkService {

    @Autowired
    private ActivitiesRemarkMapper activitiesRemarkMapper;

    /**
     * 添加市场活动备注
     * @param activityRemark
     * @return 添加的条数
     */
    @Override
    public int saveActivityRemark(ActivityRemark activityRemark) {
        return activitiesRemarkMapper.insertActivityRemark(activityRemark);
    }

    /**
     * 通过市场活动id查询市场活动所有备注信息
     * @param id
     * @return 市场活动备注集合
     */
    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailById(String id) {
        return activitiesRemarkMapper.selectActivityRemarkForDetailById(id);
    }
}
