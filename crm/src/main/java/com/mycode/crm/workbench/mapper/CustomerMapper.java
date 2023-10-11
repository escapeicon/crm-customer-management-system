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
     * 删除 通过ids
     * @param ids
     * @return
     */
    int deleteByIds(String[] ids);

    /**
     * 修改 通过customer id
     * @param customer
     * @return 修改记录条数
     */
    int updateCustomerById(Customer customer);

    /**
     * 查询客户 分页查询 通过条件
     * @param pageInfo
     * @return 客户集合
     */
    List<Customer> selectCustomerForPageByCondition(Map<String,Object> pageInfo);
    //查询上面查询结果的总条数
    int selectCountCustomerForPageByCondition(Map<String,Object> pageInfo);
    //简略查询单条 根据id
    Customer selectOneByIdCustomer(String id);
    //精细查询单条 根据id
    Customer selectOneByIdForDetail(String id);
    //详细查询 所有客户
    List<Customer> selectAllCustomerForDetail();
    //详细查询 根据name值
    List<Customer> selectCustomerListByName(String name);
    //精确查询客户 通过 name
    Customer selectCustomerByName(String name);
}