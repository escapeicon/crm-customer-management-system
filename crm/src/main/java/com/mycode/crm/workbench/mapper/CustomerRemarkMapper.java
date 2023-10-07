package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ClueRemark;
import com.mycode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);

    int insertCustomerRemarkByList(List<CustomerRemark> customerRemarks);
}