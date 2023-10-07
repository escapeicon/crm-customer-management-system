package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    List<Customer> queryCustomerForPageByCondition(Map<String,Object> pageInfo);
    int queryCountCustomerForPageByCondition(Map<String,Object> pageInfo);
}
