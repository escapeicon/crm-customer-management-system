package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {

    //添加多条联系人市场活动 通过list集合
    int insertContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList);
}