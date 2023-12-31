package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ChartObj;
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
     * 删除交易 根据id
     * @param id
     * @return
     */
    int deleteTransactionById(String id);
    //删除多条交易 根据id数组
    int deleteTransactionByIds(String[] ids);

    /**
     * 修改交易 根据id
     * @param transaction
     * @return
     */
    int updateTransactionById(Transaction transaction);

    /**
     * 查询 分页 条件
     * @param pageInfo
     * @return 交易结果集
     */
    List<Transaction> selectForPageByCondition(Map<String,Object> pageInfo);
    //查询 条件查询总条数
    int selectCountByCondition(Map<String,Object> pageInfo);
    //查询多条 用于备注页面展示 通过客户Id
    List<Transaction> selectForRemarkPageByCustomerId(String customerId);
    //查询多条 用于备注页展示 根据联系人id
    List<Transaction> selectForRemarkPageByContactId(String contactId);
    //精细查询单条 根据交易id
    Transaction selectOneById(String id);
    //精简查询单条 根据交易id
    Transaction selectOneByIdForSimple(String id);
    //查询交易总数 根据stage分组
    List<ChartObj> selectCountGroupByStage();
}