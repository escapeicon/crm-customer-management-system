package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {

    /**
     * 增添客户
     * @param customer
     * @return
     */
    int insertCustomer(Customer customer);

    /**
     * 查询客户 分页查询 通过条件
     * @param pageInfo
     * @return 客户集合
     */
    List<Customer> selectCustomerForPageByCondition(Map<String,Object> pageInfo);
    //查询上面查询结果的总条数
    int selectCountCustomerForPageByCondition(Map<String,Object> pageInfo);

}