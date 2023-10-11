package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ClueRemark;
import com.mycode.crm.workbench.domain.CustomerRemark;
import com.mycode.crm.workbench.service.CustomerRemarkService;

import java.util.List;

public interface CustomerRemarkMapper {

    /**
     * 添加 客户备注 通过集合
     * @param customerRemarks
     * @return
     */
    int insertCustomerRemarkByList(List<CustomerRemark> customerRemarks);
    //添加 客户备注
    int insertCustomerRemark(CustomerRemark customerRemark);

    /**
     * 删除客户备注 根据id
     * @param id
     * @return
     */
    int deleteCustomerRemarkById(String id);

    /**
     * 修改 客户备注 根据id
     * @param customerRemark
     * @return
     */
    int updateCustomerRemarkById(CustomerRemark customerRemark);

    /**
     * 查询 客户备注 通过客户id
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectCustomerRemarkByCustomerId(String customerId);
    //查询单条客户备注 通过客户备注id
    CustomerRemark selectCustomerRemarkForDetailById(String id);
}