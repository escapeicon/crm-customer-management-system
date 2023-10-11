package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Contacts;
import com.mycode.crm.workbench.mapper.ContactsMapper;
import com.mycode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    /**
     * 添加 联系人
     * @param contacts
     * @return
     */
    @Override
    public int saveContact(Contacts contacts) {
        return contactsMapper.insertContact(contacts);
    }

    /**
     * 查询 分页 by 条件
     * @param pageInfo
     * @return
     */
    @Override
    public List<Contacts> queryForPageByCondition(Map<String, Object> pageInfo) {
        return contactsMapper.selectContactsForPageByCondition(pageInfo);
    }
    //条件查询的总条数
    @Override
    public int queryCountByCondition(Map<String, Object> pageInfo) {
        return contactsMapper.selectCountByCondition(pageInfo);
    }
    //查询多条 用于备注页面展示 通过客户id
    @Override
    public List<Contacts> queryForRemarkPageByCustomerId(String customerId) {
        return contactsMapper.selectContactsForRemarkPageByCustomerId(customerId);
    }
    //查询所有 精细查询
    @Override
    public List<Contacts> queryAllForDetail() {
        return contactsMapper.selectAllForDetail();
    }
    //精细查询单条
    @Override
    public Contacts queryOneForDetail(String id) {
        return contactsMapper.selectOneByIdForDetail(id);
    }
}
