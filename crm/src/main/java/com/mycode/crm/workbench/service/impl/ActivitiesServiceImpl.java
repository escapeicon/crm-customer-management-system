package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.mapper.ActivitiesMapper;
import com.mycode.crm.workbench.service.ActivitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("activitiesService")
public class ActivitiesServiceImpl implements ActivitiesService {

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
     * 以集合形式保存市场活动
     * @param activities
     * @return 影响数据库记录条数
     */
    @Override
    public int saveActivitiesByList(List<Activity> activities) {
        return activitiesMapper.insertActivitiesByList(activities);
    }

    /**
     * 根据id修改市场活动信息
     * @param activity 市场活动实体类
     * @return 更新条数
     */
    @Override
    public int saveEditActivity(Activity activity) {
        return activitiesMapper.updateByIdSelective(activity);
    }

    /**
     * 根据id删除市场活动
     * @param id 市场活动id
     * @return 删除条数
     */
    @Override
    public int deleteActivityByIds(String[] ids) {
        return activitiesMapper.deleteActivityByIds(ids);
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



    /**
     * 根据id查询指定市场活动
     * @param id
     * @return 市场活动信息
     */
    @Override
    public Activity queryActivityById(String id) {
        return activitiesMapper.selectById(id);
    }

    /**
     * 获取所有市场活动
     * @return 市场活动集合
     */
    @Override
    public List<Activity> queryAllActivities() {
        return activitiesMapper.selectAllActivities();
    }

    /**
     * 根据id数组查询市场活动
     * @param ids
     * @return 查询市场活动结果
     */
    @Override
    public List<Activity> queryActivitiesByIds(String[] ids) {
        return activitiesMapper.selectActivitiesByIds(ids);
    }

    /**
     * 根据id查看市场活动明细信息
     * @param id
     * @return 市场活动
     */
    @Override
    public Activity queryActivityByIdForDetail(String id) {
        return activitiesMapper.selectActivitiyByIdForDetais(id);
    }

    /**
     * 查询市场活动集合 for 线索页面 根据 线索id
     * @param clueId
     * @return 市场活动集合
     */
    @Override
    public List<Activity> queryActivitiesByClueIdForClueRemarkPage(String clueId) {
        return activitiesMapper.selectActivitiesByClueIdForClueRemarkPage(clueId);
    }

    /**
     * 查询所有市场活动 for 线索页面 by 线索id exclude 已绑定的线索
     * @param clueId
     * @return 市场活动集合
     */
    @Override
    public List<Activity> queryAllActivitiesForClueRemarkPageByClueIdExcludeBundled(String clueId) {
        return activitiesMapper.selectAllActivitiesForClueRemarkExcludeBundledByClueId(clueId);
    }

    /**
     * 查询 已经同线索关联的市场活动
     * @param clueId
     * @return 市场活动集合
     */
    @Override
    public List<Activity> queryActivitiesForClueConvertByClueId(String clueId) {
        return activitiesMapper.selectActivitiesForClueConvertBundledByClueId(clueId);
    }
    //查询一个联系人关联的所有市场活动 根据联系人id
    @Override
    public List<Activity> queryActivitiesForContactRelationByContactId(String contactId) {
        return activitiesMapper.selectActivitiesForContactRelationByContactId(contactId);
    }
    //查询所有联系人未绑定的市场活动 根据联系人id
    @Override
    public List<Activity> queryActivitiesForContactUnBundledByContactId(String contactId) {
        return activitiesMapper.selectAllActivitiesForContactRemarkExcludeBundledByContactId(contactId);
    }
}
