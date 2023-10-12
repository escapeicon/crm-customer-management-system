package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivitiesMapper {

    /**
     * 添加单条市场活动
     * @param record
     * @return 数据库更新条数
     */
    int insert(Activity record);
    /**
     * 动态添加单条市场活动
     * @param record
     * @return 数据库更新条数
     */
    int insertSelective(Activity record);
    /**
     * 添加多个市场活动
     * @param activities
     * @return 数据库影响条数
     */
    int insertActivitiesByList(List<Activity> activities);


    /**
     * 根据id删除指定市场活动
     * @param id
     * @return 数据库更新条数
     */
    int deleteByPrimaryKey(String id);
    /**
     * 根据id删除市场活动记录条数
     * @param ids
     * @return 删除的记录条数
     */
    int deleteActivityByIds(@Param("ids") String[] ids);


    /**
     * 根据id修改市场活动信息
     * @param activity 市场活动信息
     * @return 更新条数
     */
    int updateByIdSelective(Activity activity);
    /**
     * 根据id修改指定市场活动
     * @param record
     * @return 数据库更新条数
     */
    int updateByPrimaryKey(Activity record);


    /**
     * 查询分页查询所查到的记录总数
     * @param pageInfo 封装的页面信息
     * @return 记录总数
     */
    int selectCountOfActivityByCondition(Map<String,Object> pageInfo);
    /**
     * 获取全部市场活动信息
     * @return 全部市场活动集合
     */
    List<Activity> selectAllActivities();
    /**
     * 根据市场活动id查询市场活动信息
     * @param id
     * @return 市场活动信息
     */
    Activity selectById(String id);
    /**
     * 分页查询
     * @param pageInfo 封装的页面信息
     * @return 所查询到的所有记录
     */
    List<Activity> selectActivityByConditionForPage(Map<String,Object> pageInfo);
    /**
     * 通过id集合查询市场活动
     * @param ids
     * @return 查询到的市场活动集合
     */
    List<Activity> selectActivitiesByIds(String[] ids);
    /**
     * 通过id获取市场活动明细信息，用于查看市场活动明细
     * @param id
     * @return 市场活动信息
     */
    Activity selectActivitiyByIdForDetais(String id);
    /**
     * 查询多条市场活动 根据线索id for 线索备注页面
     * @param id
     * @return 市场活动集合
     */
    List<Activity> selectActivitiesByClueIdForClueRemarkPage(String id);
    /**
     * 查询多条市场活动 for 线索备注 排除线索备注已绑定的市场活动
     * @param clueId
     * @return 市场活动集合
     */
    List<Activity> selectAllActivitiesForClueRemarkExcludeBundledByClueId(String clueId);
    //查询多条市场活动 for 线索转换 查询该线索已绑定的市场活动
    List<Activity> selectActivitiesForClueConvertBundledByClueId(String Clueid);
    //查询一个联系人关联的所有市场活动 根据联系人id
    List<Activity> selectActivitiesForContactRelationByContactId(String contactId);
    //查询联系人未绑定的市场活动
    List<Activity> selectAllActivitiesForContactRemarkExcludeBundledByContactId(String contactId);
}