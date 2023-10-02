package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    /**
     * 创建线索
     * @param clue
     * @return 数据库更新条数
     */
    int insertClue(Clue clue);

    /**
     * 删除线索 根据id
     * @param ids
     * @return 数据库更新条数
     */
    int deleteClueByIds(String[] ids);

    /**
     * 修改线索 根据id
     * @param clue
     * @return 数据库记录更新条数
     */
    int updateClue(Clue clue);

    /**
     * 分页查询 条件查询
     * @param pageInfo
     * @return 查询结果集
     */
    List<Clue> selectClueByConditionForPage(Map<String,Object> pageInfo);
    int selectCountClueByConditionForPage(Map<String,Object> pageInfo);//分页查询总条数
    /**
     * 查询所有线索
     * @return 线索集合
     */
    List<Clue> selectAllClue();
    /**
     * 查询单条线索 根据id
     * @param id
     * @return 线索实体类
     */
    Clue selectClueById(String id);
    /**
     * 查询单条线索 for detail 根据id
     * @param id
     * @return 线索实体类
     */
    Clue selectClueForRemarkById(String id);
}