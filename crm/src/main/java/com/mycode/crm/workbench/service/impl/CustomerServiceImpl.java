package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.mapper.CustomerMapper;
import com.mycode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    /**
     * 查询多个客户 根据条件 分页查询
     * @param pageInfo
     * @return 客户集合
     */
    @Override
    public List<Customer> queryCustomerForPageByCondition(Map<String, Object> pageInfo) {
        return customerMapper.selectCustomerForPageByCondition(pageInfo);
    }
    //查询 以上查询结果的总条数
    @Override
    public int queryCountCustomerForPageByCondition(Map<String, Object> pageInfo) {
        return customerMapper.selectCountCustomerForPageByCondition(pageInfo);
    }
}
