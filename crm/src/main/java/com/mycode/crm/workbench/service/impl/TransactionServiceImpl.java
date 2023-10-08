package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.mapper.TransactionMapper;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionMapper transactionMapper;

    /**
     * 查询 条件查询 分页查询
     * @param pageInfo
     * @return
     */
    @Override
    public List<Transaction> queryForPageByCondition(Map<String, Object> pageInfo) {
        return transactionMapper.selectForPageByCondition(pageInfo);
    }
    //条件查询 总条数
    @Override
    public int queryCountByCondition(Map<String, Object> pageInfo) {
        return transactionMapper.selectCountByCondition(pageInfo);
    }
}
