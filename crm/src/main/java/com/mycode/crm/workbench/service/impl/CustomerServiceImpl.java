package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.mapper.ContactsMapper;
import com.mycode.crm.workbench.mapper.CustomerMapper;
import com.mycode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;

    /**
     * 保存客户
     * @param customer
     * @return
     */
    @Override
    public int saveCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    /**
     * 删除 根据ids
     * @param ids
     * @return 删除条数
     */
    @Override
    public int deleteCustomerByIds(String[] ids) {
        int count = contactsMapper.deleteContactByCustomerIds(ids);
        count += customerMapper.deleteByIds(ids);
        return count;
    }

    /**
     * 修改 客户 根据id
     * @param customer
     * @return
     */
    @Override
    public int modifyCustomer(Customer customer) {
        return customerMapper.updateCustomerById(customer);
    }

    /**
     * 查询多个客户 根据条件 分页查询
     * @param pageInfo
     * @return 客户集合
     */
    @Override
    public List<Customer> queryCustomerForPageByCondition(Map<String, Object> pageInfo) {
        return customerMapper.selectCustomerForPageByCondition(pageInfo);
    }
    //查询 以上查询结果的总条数
    @Override
    public int queryCountCustomerForPageByCondition(Map<String, Object> pageInfo) {
        return customerMapper.selectCountCustomerForPageByCondition(pageInfo);
    }
    //简略查询 单个客户 根据客户id
    @Override
    public Customer queryOneById(String id) {
        return customerMapper.selectOneByIdCustomer(id);
    }
    //精细查询 所有
    @Override
    public List<Customer> queryAllForDetail() {
        return customerMapper.selectAllCustomerForDetail();
    }
    //精细查询 模糊查询name
    @Override
    public List<Customer> queryCustomerListByName(String name) {
        return customerMapper.selectCustomerListByName(name);
    }
    //精确查询 通过name
    @Override
    public Customer queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }
    //精细查询 通过id
    @Override
    public Customer queryOneByIdForDetail(String id) {
        return customerMapper.selectOneByIdForDetail(id);
    }
}
