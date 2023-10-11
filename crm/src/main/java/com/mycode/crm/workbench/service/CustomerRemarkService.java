package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.CustomerRemark;
import com.mycode.crm.workbench.service.impl.CustomerRemarkServiceImpl;

import java.util.List;

public interface CustomerRemarkService {

    int saveCustomerRemark(CustomerRemark customerRemark);

    int deleteCustomerRemarkById(String id);

    int updateCustomerRemark(CustomerRemark customerRemark);

    List<CustomerRemark> queryCustomerRemarkForListByCustomerId(String customerId);
    CustomerRemark queryCustomerRemarkForDetailById(String id);
}
