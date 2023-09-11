package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.MarketingActivities;

public interface MarketingActivitiesMapper {
    int deleteByPrimaryKey(String id);

    int insert(MarketingActivities record);

    int insertSelective(MarketingActivities record);

    MarketingActivities selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(MarketingActivities record);

    int updateByPrimaryKey(MarketingActivities record);
}