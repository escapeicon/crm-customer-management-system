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

    /**
     * 删除联系人备注 根据联系人id
     * @param contactsId
     * @return
     */
    int deleteContactsRemarkByContactId(String contactsId);

    /**
     * 精确查询多条联系人备注 根据联系人id
     */
    List<ContactsRemark> selectContactsRemarkByContactId(String contactId);
}