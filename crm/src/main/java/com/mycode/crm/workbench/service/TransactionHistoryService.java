package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {

    List<TransactionHistory> queryByTransactionIdForList(String transactionId);
    TransactionHistory queryOneById(String id);
}
