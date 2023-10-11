package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ClueRemark;
import com.mycode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {

    /**
     * 添加 客户备注 通过集合
     * @param customerRemarks
     * @return
     */
    int insertCustomerRemarkByList(List<CustomerRemark> customerRemarks);

    /**
     * 查询 客户备注 通过客户id
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectCustomerRemarkByCustomerId(String customerId);
}