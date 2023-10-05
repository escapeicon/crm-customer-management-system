package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Customer;

public interface CustomerMapper {

    int insert(Customer record);
    int insertSelective(Customer record);
    int insertCustomer(Customer customer);

    int deleteByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer record);
    int updateByPrimaryKey(Customer record);

    Customer selectByPrimaryKey(String id);
}