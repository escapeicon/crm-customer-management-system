package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkMapper {

    /**
     * 插入多条 交易备注 通过list集合
     * @param transactionRemarkList
     * @return 插入记录条数
     */
    int insertTransactionRemarkByList(List<TransactionRemark> transactionRemarkList);
}