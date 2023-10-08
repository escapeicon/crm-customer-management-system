package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionMapper {

    /**
     * 插入一条 交易
     * @param transaction
     * @return 插入记录条数
     */
    int insertTransaction(Transaction transaction);

    /**
     * 查询 分页 条件
     * @param pageInfo
     * @return 交易结果集
     */
    List<Transaction> selectForPageByCondition(Map<String,Object> pageInfo);
    //查询 条件查询总条数
    int selectCountByCondition(Map<String,Object> pageInfo);

}