package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.mapper.TransactionMapper;

import java.util.List;
import java.util.Map;

public interface TransactionService {

    List<Transaction> queryForPageByCondition(Map<String,Object> pageInfo);
    int queryCountByCondition(Map<String,Object> pageInfo);
}
