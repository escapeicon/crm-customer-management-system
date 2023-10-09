package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    int saveCustomer(Customer customer);

    int deleteCustomerByIds(String[] ids);

    int modifyCustomer(Customer customer);

    List<Customer> queryCustomerForPageByCondition(Map<String,Object> pageInfo);
    int queryCountCustomerForPageByCondition(Map<String,Object> pageInfo);
    Customer queryOneById(String id);
}
