package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Contacts;

public interface ContactsMapper {

    int insert(Contacts record);
    int insertSelective(Contacts record);
    //新增联系人
    int insertContact(Contacts contacts);

    int deleteByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contacts record);
    int updateByPrimaryKey(Contacts record);

    Contacts selectByPrimaryKey(String id);
}