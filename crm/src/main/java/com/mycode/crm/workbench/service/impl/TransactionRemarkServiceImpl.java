package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.TransactionRemark;
import com.mycode.crm.workbench.mapper.TransactionRemarkMapper;
import com.mycode.crm.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("transactionRemarkService")
public class TransactionRemarkServiceImpl implements TransactionRemarkService {

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    /**
     * 查询交易备注 根据交易id
     * @param transactionId
     * @return
     */
    @Override
    public List<TransactionRemark> queryByTransactionIdForList(String transactionId) {
        return transactionRemarkMapper.selectByTransactionIdForList(transactionId);
    }
}
