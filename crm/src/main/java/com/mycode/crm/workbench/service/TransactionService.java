package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.mapper.TransactionMapper;

import java.util.List;
import java.util.Map;

public interface TransactionService {

    void saveTransaction(Map<String,Object> map) throws Exception;

    void deleteTransactionById(String id) throws Exception;
    void deleteTransactionByIds(String[] ids) throws Exception;

    void updateTransactionById(Map<String,Object> map) throws Exception;
    void updateTransactionStageById(Map<String,Object> map) throws Exception;

    List<Transaction> queryForPageByCondition(Map<String,Object> pageInfo);
    int queryCountByCondition(Map<String,Object> pageInfo);
    List<Transaction> queryForRemarkPageByCustomerId(String customerId);
    List<Transaction> queryForRemarkPageByContactId(String contactId);
    Transaction queryOneById(String id);
    Transaction queryOneByIdForSimple(String id);
}
