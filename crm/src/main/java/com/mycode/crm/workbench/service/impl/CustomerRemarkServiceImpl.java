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
     * 添加客户备注
     * @param customerRemark
     * @return
     */
    @Override
    public int saveCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    /**
     * 删除客户备注 根据id
     * @param id
     * @return
     */
    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }

    /**
     * 修改客户备注 通过客户备注id
     * @param customerRemark
     * @return
     */
    @Override
    public int updateCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemarkById(customerRemark);
    }

    /**
     * 查询 客户备注 通过客户id
     * @param customerId
     * @return
     */
    @Override
    public List<CustomerRemark> queryCustomerRemarkForListByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkByCustomerId(customerId);
    }
    //精细查询单条客户备注 通过客户备注id
    @Override
    public CustomerRemark queryCustomerRemarkForDetailById(String id) {
        return customerRemarkMapper.selectCustomerRemarkForDetailById(id);
    }
}
