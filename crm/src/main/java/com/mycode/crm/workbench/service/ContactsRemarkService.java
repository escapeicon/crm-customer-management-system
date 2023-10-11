package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    int saveContactsRemarkByList(List<ContactsRemark> contactsRemarkList);
    int saveContactsRemark(ContactsRemark contactsRemark);

    int deleteContactsRemarkByContactId(String contactId);
    int deleteContactsRemarkById(String id);


    int updateContactsRemarkById(ContactsRemark contactsRemark);

    List<ContactsRemark> queryContactsRemarkByContactId(String contactId);
    ContactsRemark queryOneById(String id);

}
