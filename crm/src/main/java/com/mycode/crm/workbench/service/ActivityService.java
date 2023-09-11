package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.MarketingActivities;
import org.springframework.stereotype.Service;

public interface ActivityService {
    /**
     * 创建市场活动
     * @return 数据库更新条数
     */
    int create(MarketingActivities marketingActivities);
}
