package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ContactActivityRelation;

public interface ContactActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactActivityRelation record);

    int insertSelective(ContactActivityRelation record);

    ContactActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ContactActivityRelation record);

    int updateByPrimaryKey(ContactActivityRelation record);
}