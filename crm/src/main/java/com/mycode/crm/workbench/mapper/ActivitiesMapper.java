package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Activity;

public interface ActivitiesMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);
}