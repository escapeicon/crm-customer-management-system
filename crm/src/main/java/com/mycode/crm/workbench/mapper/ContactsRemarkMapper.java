package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {
    /**
     * 添加联系人备注 通过list集合
     * @param contactsRemarkList
     * @return
     */
    int insertContactsRemarkByList(List<ContactsRemark> contactsRemarkList);
    //添加一条联系人
    int insertContactRemark(ContactsRemark contactsRemark);

    /**
     * 删除联系人备注 根据联系人id
     * @param contactsId
     * @return
     */
    int deleteContactsRemarkByContactId(String contactsId);
    //删除联系人备注 根据id
    int deleteContactsRemarkById(String id);

    /**
     * 修改联系人备注 根据id
     * @param contactsRemark
     * @return
     */
    int updateContactsRemarkById(ContactsRemark contactsRemark);

    /**
     * 精确查询多条联系人备注 根据联系人id
     */
    List<ContactsRemark> selectContactsRemarkByContactId(String contactId);
    //精确查询一条 根据id
    ContactsRemark selectOneById(String id);
}