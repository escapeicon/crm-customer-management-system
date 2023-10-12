package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.mapper.UserMapper;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.domain.TransactionHistory;
import com.mycode.crm.workbench.mapper.CustomerMapper;
import com.mycode.crm.workbench.mapper.TransactionHistoryMapper;
import com.mycode.crm.workbench.mapper.TransactionMapper;
import com.mycode.crm.workbench.mapper.TransactionRemarkMapper;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    /**
     * 添加 交易
     * @param map
     */
    @Override
    public void saveTransaction(Map<String,Object> map) throws Exception{
        String name = (String) map.get("customerId");
        User user = (User) map.get("user");

        Customer customer = customerMapper.selectCustomerByName(name);//从数据库查询该条客户通过name

        //如果为null 则新建客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(user.getId());
            customer.setName(name);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateFormat.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);//创建新客户
        }

        //封装交易实体类
        Transaction transaction = new Transaction();
        transaction.setId(UUIDUtil.getUUID());
        transaction.setOwner(user.getId());
        transaction.setMoney((String) map.get("money"));
        transaction.setName((String) map.get("name"));
        transaction.setExpectedDate((String) map.get("expectedDate"));
        transaction.setCustomerId(customer.getId());
        transaction.setStage((String) map.get("stage"));
        transaction.setType((String) map.get("type"));
        transaction.setSource((String) map.get("source"));
        transaction.setActivityId((String) map.get("activityId"));
        transaction.setContactsId((String) map.get("contactsId"));
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateFormat.formatDateTime(new Date()));
        transaction.setDescription((String) map.get("description"));
        transaction.setContactSummary((String) map.get("contactSummary"));
        transaction.setNextContactTime((String) map.get("nextContactTime"));
        //添加一条交易
        transactionMapper.insertTransaction(transaction);

        //添加一条交易历史
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtil.getUUID());
        transactionHistory.setStage(transaction.getStage());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setCreateTime(DateFormat.formatDateTime(new Date()));
        transactionHistory.setCreateBy(user.getId());
        transactionHistory.setTransactionId(transaction.getId());

        transactionHistoryMapper.insertTransactionHistory(transactionHistory);
    }

    /**
     * 删除交易 根据id
     * @param id
     * @return
     */
    @Override
    public void deleteTransactionById(String id) throws Exception{
        //删除交易备注
        transactionRemarkMapper.deleteTransactionRemarkByTransactionId(id);
        //删除交易
        transactionMapper.deleteTransactionById(id);
    }

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
    //查询多条 用于备注页面展示 通过客户id
    @Override
    public List<Transaction> queryForRemarkPageByCustomerId(String customerId) {
        return transactionMapper.selectForRemarkPageByCustomerId(customerId);
    }
    //查询多条 用于备注页面展示 通过联系人id
    @Override
    public List<Transaction> queryForRemarkPageByContactId(String contactId) {
        return transactionMapper.selectForRemarkPageByContactId(contactId);
    }
    //查询单条 根据交易id
    @Override
    public Transaction queryOneById(String id) {
        return transactionMapper.selectOneById(id);
    }
}
