package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {

    int insert(ClueActivityRelation record);
    int insertSelective(ClueActivityRelation record);
    //批量导入线索市场活动关联关系
    int insertClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList);

    int deleteByPrimaryKey(String id);
    //删除线索市场活动关系 根据实体类对象
    int deleteClueActivityRelationByObject(ClueActivityRelation clueActivityRelation);
    //删除线索 通过线索id
    int deleteClueActivityRelationByClueId(String clueId);

    int updateByPrimaryKeySelective(ClueActivityRelation record);
    int updateByPrimaryKey(ClueActivityRelation record);

    ClueActivityRelation selectByPrimaryKey(String id);
    //根据线索id 查询所有该线索绑定的线索市场活动关系
    List<ClueActivityRelation> selectClueActivityRelationListByClueId(String clueId);
}