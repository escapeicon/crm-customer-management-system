package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.CustomerRemark;
import com.mycode.crm.workbench.service.impl.CustomerRemarkServiceImpl;

import java.util.List;

public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkForListByCustomerId(String customerId);
}
