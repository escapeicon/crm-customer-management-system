package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivitiesMapper {
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


    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    int updateByPrimaryKey(Activity record);

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
}