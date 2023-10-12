package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {

    List<TransactionRemark> queryByTransactionIdForList(String transactionId);
}
