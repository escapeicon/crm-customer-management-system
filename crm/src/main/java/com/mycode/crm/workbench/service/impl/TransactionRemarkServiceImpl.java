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
     * 保存一条交易备注
     * @param transactionRemark
     * @return
     */
    @Override
    public int saveTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.insertTransactionRemark(transactionRemark);
    }

    /**
     * 删除多条交易备注 根据交易id
     * @param transactionId
     * @return
     */
    @Override
    public int deleteTransactionRemarkByTransactionId(String transactionId) {
        return transactionRemarkMapper.deleteTransactionRemarkByTransactionId(transactionId);
    }
    //删除一条交易备注 根据id
    @Override
    public int deleteTransactionRemarkById(String id) {
        return transactionRemarkMapper.deleteTransactionRemarkById(id);
    }

    /**
     * 修改一条交易备注 根据id
     * @param transactionRemark
     * @return
     */
    @Override
    public int updateTransactionRemarkById(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.updateTransactionRemarkById(transactionRemark);
    }

    /**
     * 查询交易备注 根据交易id
     * @param transactionId
     * @return
     */
    @Override
    public List<TransactionRemark> queryByTransactionIdForList(String transactionId) {
        return transactionRemarkMapper.selectByTransactionIdForList(transactionId);
    }
    //查询一条交易备注 根据交易备注id
    @Override
    public TransactionRemark queryOneById(String id) {
        return transactionRemarkMapper.selectOneByIdTransactionRemark(id);
    }
}
