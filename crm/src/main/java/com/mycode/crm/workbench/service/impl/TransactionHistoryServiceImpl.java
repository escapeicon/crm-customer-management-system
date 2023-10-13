package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.TransactionHistory;
import com.mycode.crm.workbench.mapper.TransactionHistoryMapper;
import com.mycode.crm.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("transactionHistoryService")
public class TransactionHistoryServiceImpl implements TransactionHistoryService {

    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    /**
     * 查询多条交易历史 根据交易id
     * @param transactionId
     * @return
     */
    @Override
    public List<TransactionHistory> queryByTransactionIdForList(String transactionId) {
        return transactionHistoryMapper.selectByTransactionIdForList(transactionId);
    }
    //查询一条交易历史 根据id
    @Override
    public TransactionHistory queryOneById(String id) {
        return transactionHistoryMapper.selectOneByIdTransactionHistory(id);
    }
}
