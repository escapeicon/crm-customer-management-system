package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivitiesMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    List<Activity> selectActivityByConditionForPage(Map<String,Object> pageInfo);

    int selectCountOfActivityByCondition(Map<String,Object> pageInfo);
}