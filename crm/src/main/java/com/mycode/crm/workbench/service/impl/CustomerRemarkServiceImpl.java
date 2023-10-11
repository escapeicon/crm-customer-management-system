package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.CustomerRemark;
import com.mycode.crm.workbench.mapper.CustomerRemarkMapper;
import com.mycode.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("customerRemarkService")
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    /**
     * 查询 客户备注 通过客户id
     * @param customerId
     * @return
     */
    @Override
    public List<CustomerRemark> queryCustomerRemarkForListByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkByCustomerId(customerId);
    }
}
