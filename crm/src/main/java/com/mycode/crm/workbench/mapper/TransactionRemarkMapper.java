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
    //插入一条交易备注
    int insertTransactionRemark(TransactionRemark transactionRemark);

    /**
     * 删除多条交易备注 根据交易id
     * @param transactionId
     * @return
     */
    int deleteTransactionRemarkByTransactionId(String transactionId);
    //删除一条交易备注 根据交易备注id
    int deleteTransactionRemarkById(String id);

    /**
     * 修改一条交易备注 根据id
     * @param transactionRemark
     * @return
     */
    int updateTransactionRemarkById(TransactionRemark transactionRemark);

    /**
     * 查询多条 交易备注 根据交易id
     * @param transactionId
     * @return
     */
    List<TransactionRemark> selectByTransactionIdForList(String transactionId);
    //查询一条交易备注 根据交易备注id
    TransactionRemark selectOneByIdTransactionRemark(String id);
}