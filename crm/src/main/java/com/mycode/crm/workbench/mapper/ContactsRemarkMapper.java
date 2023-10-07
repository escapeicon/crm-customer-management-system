package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {
    int insertContactsRemarkByList(List<ContactsRemark> contactsRemarkList);
}