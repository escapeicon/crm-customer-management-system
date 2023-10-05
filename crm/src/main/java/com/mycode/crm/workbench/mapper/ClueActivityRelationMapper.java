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

    int updateByPrimaryKeySelective(ClueActivityRelation record);
    int updateByPrimaryKey(ClueActivityRelation record);

    ClueActivityRelation selectByPrimaryKey(String id);
}