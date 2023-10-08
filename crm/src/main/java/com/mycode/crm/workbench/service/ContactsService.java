package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryForPageByCondition(Map<String,Object> pageInfo);
    int queryCountByCondition(Map<String,Object> pageInfo);
}
