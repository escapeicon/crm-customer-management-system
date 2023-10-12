package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.ContactsActivityRelation;
import com.mycode.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.mycode.crm.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("contactsActivityRelationService")
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    /**
     * 绑定多条联系人市场活动关系
     * @param contactsActivityRelationList
     * @return
     */
    @Override
    public int saveContactsActivityForList(List<ContactsActivityRelation> contactsActivityRelationList) {
        return contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelationList);
    }

    /**
     * 删除 联系人市场活动关联关系 根据 两者id
     * @param contactId
     * @param activityId
     * @return
     */
    @Override
    public int deleteByContactIdAndActivityId(String contactId, String activityId) {
        return contactsActivityRelationMapper.deleteByContactIdAndActivityId(contactId,activityId);
    }
}
