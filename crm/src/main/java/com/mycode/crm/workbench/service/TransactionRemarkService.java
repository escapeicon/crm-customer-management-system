package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {

    int saveTransactionRemark(TransactionRemark transactionRemark);

    int deleteTransactionRemarkByTransactionId(String transactionId);
    int deleteTransactionRemarkById(String id);

    int updateTransactionRemarkById(TransactionRemark transactionRemark);

    List<TransactionRemark> queryByTransactionIdForList(String transactionId);
    TransactionRemark queryOneById(String id);
}
