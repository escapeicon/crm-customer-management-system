package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Transaction;

public interface TransactionMapper {

    /**
     * 插入一条 交易
     * @param transaction
     * @return 插入记录条数
     */
    int insertTransaction(Transaction transaction);

}