package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.mapper.ActivitiesMapper;
import com.mycode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivitiesMapper activitiesMapper;

    /**
     * 创建市场活动
     * @param activity
     * @return 数据库更新条数
     */
    @Override
    public int saveCreateActivity(Activity activity) {
        return activitiesMapper.insertSelective(activity);
    }

    /**
     * 根据分页数据查询指定市场活动数据
     * @param pageInfo
     * @return 市场活动list集合
     */
    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> pageInfo) {
        return activitiesMapper.selectActivityByConditionForPage(pageInfo);
    }

    /**
     * 查询分页查询的结果条数的总和
     * @param pageInfo
     * @return 结果条数的总和
     */
    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> pageInfo) {
        return activitiesMapper.selectCountOfActivityByCondition(pageInfo);
    }


}
