package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.TransactionHistory;

public interface TransactionHistoryMapper {

    /**
     * 添加 交易历史
     * @param transactionHistory
     * @return
     */
    int insertTransactionHistory(TransactionHistory transactionHistory);
}