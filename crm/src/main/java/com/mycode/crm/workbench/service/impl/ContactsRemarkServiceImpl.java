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
    //添加一个联系人
    @Override
    public int saveContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactRemark(contactsRemark);
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
    //删除联系人备注 根据id
    @Override
    public int deleteContactsRemarkById(String id) {
        return contactsRemarkMapper.deleteContactsRemarkById(id);
    }

    /**
     * 修改联系人备注 根据联系人备注id
     * @param contactsRemark
     * @return
     */
    @Override
    public int updateContactsRemarkById(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateContactsRemarkById(contactsRemark);
    }

    /**
     * 查询多条联系人备注 根据联系人id
     * @param contactId
     * @return
     */
    @Override
    public List<ContactsRemark> queryContactsRemarkByContactId(String contactId) {
        return contactsRemarkMapper.selectContactsRemarkByContactId(contactId);
    }
    //精细查询一条联系人备注 根据联系人备注id
    @Override
    public ContactsRemark queryOneById(String id) {
        return contactsRemarkMapper.selectOneById(id);
    }
}
