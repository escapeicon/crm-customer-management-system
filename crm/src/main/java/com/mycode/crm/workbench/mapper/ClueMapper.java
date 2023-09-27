package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

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
}