package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    int saveContact(Contacts contacts);

    List<Contacts> queryForPageByCondition(Map<String,Object> pageInfo);
    int queryCountByCondition(Map<String,Object> pageInfo);
    List<Contacts> queryForRemarkPageByCustomerId(String customerId);
    List<Contacts> queryAllForDetail();
    Contacts queryOneForDetail(String id);
}
