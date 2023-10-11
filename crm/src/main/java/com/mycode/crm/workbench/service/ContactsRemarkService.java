package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    int saveContactsRemarkByList(List<ContactsRemark> contactsRemarkList);

    int deleteContactsRemarkByContactId(String contactId);

    List<ContactsRemark> queryContactsRemarkByContactId(String contactId);

}
