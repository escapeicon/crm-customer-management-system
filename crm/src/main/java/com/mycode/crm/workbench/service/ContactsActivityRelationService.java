package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {
    int saveContactsActivityForList(List<ContactsActivityRelation> contactsActivityRelationList);

    int deleteByContactIdAndActivityId(String contactId,String activityId);
}
