package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.ContactsRemark;
import com.mycode.crm.workbench.mapper.ContactsRemarkMapper;
import com.mycode.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("contactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    /**
     * 添加联系人备注 通过list集合
     * @param contactsRemarkList
     * @return
     */
    @Override
    public int saveContactsRemarkByList(List<ContactsRemark> contactsRemarkList) {
        return contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
    }

    /**
     * 删除联系人备注 根据联系人id
     * @param contactId
     * @return
     */
    @Override
    public int deleteContactsRemarkByContactId(String contactId) {
        return contactsRemarkMapper.deleteContactsRemarkByContactId(contactId);
    }
}
