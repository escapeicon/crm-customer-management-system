package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.TransactionHistory;

import java.util.List;

public interface TransactionHistoryMapper {

    /**
     * 添加 交易历史
     * @param transactionHistory
     * @return
     */
    int insertTransactionHistory(TransactionHistory transactionHistory);

    /**
     * 查询多条交易历史 根据交易id
     * @param transactionId
     * @return
     */
    List<TransactionHistory> selectByTransactionIdForList(String transactionId);
}