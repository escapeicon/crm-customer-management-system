package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.MarketingActivities;
import com.mycode.crm.workbench.mapper.MarketingActivitiesMapper;
import com.mycode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private MarketingActivitiesMapper marketingActivitiesMapper;

    /**
     * 创建市场活动
     * @param marketingActivities
     * @return 数据库更新条数
     */
    @Override
    public int create(MarketingActivities marketingActivities) {
        return marketingActivitiesMapper.insertSelective(marketingActivities);
    }
}
