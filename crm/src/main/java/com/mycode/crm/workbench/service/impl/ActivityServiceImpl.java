package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.mapper.ActivitiesMapper;
import com.mycode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("activityService")
@Transactional
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivitiesMapper activitiesMapper;

    /**
     * 创建市场活动
     * @param activity
     * @return 数据库更新条数
     */
    @Override
    public int create(Activity activity) {
        return activitiesMapper.insertSelective(activity);
    }
}
