package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.workbench.domain.Contacts;
import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.mapper.ContactsMapper;
import com.mycode.crm.workbench.mapper.ContactsRemarkMapper;
import com.mycode.crm.workbench.mapper.CustomerMapper;
import com.mycode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    /**
     * 添加 联系人
     * @param contacts
     * @return
     */
    @Override
    public int saveContact(Contacts contacts) {
        return contactsMapper.insertContact(contacts);
    }
    //添加 联系人 进行客户规则判断
    @Override
    public void saveContactForManual(Map<String, Object> map) {
        User user = (User) map.get("user");
        String customerName = (String) map.get("customer");
        Customer customer = customerMapper.selectCustomerByName(customerName);//对客户名进行查询
        //如果查询到的客户为空则创建一个新客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateFormat.formatDateTime(new Date()));
            customer.setCreateBy(user.getId());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customerMapper.insertCustomer(customer);
        }
        //封装联系人实体类
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource((String) map.get("source"));
        contacts.setCustomer(customer.getId());
        contacts.setFullname((String) map.get("fullname"));
        contacts.setAppellation((String) map.get("appellation"));
        contacts.setEmail((String) map.get("email"));
        contacts.setMphone((String) map.get("mphone"));
        contacts.setJob((String) map.get("job"));
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateFormat.formatDateTime(new Date()));
        contacts.setDescription((String) map.get("description"));
        contacts.setContactSummary((String) map.get("contactSummary"));
        contacts.setNextContactTime((String) map.get("nextContactTime"));
        contacts.setAddress((String) map.get("address"));
        contactsMapper.insertContact(contacts);
    }

    /**
     * 删除联系人 通过id数组
     * @param ids
     * @return
     */
    @Override
    public int deleteContactByIds(String[] ids) {
        return contactsMapper.deleteContactByIds(ids);
    }
    //删除联系人 根据id
    @Override
    public void deleteContactById(String id) {
        contactsRemarkMapper.deleteContactsRemarkByContactId(id);//删除该联系人所有备注
        contactsMapper.deleteContactById(id);//删除该联系人
    }

    /**
     * 修改联系人 根据id
     * @param map
     */
    @Override
    public void updateContactById(Map<String,Object> map) {
        User user = (User) map.get("user");
        String customerName = (String) map.get("customer");
        Customer customer = customerMapper.selectCustomerByName(customerName);//对客户名进行查询
        //如果查询到的客户为空则创建一个新客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateFormat.formatDateTime(new Date()));
            customer.setCreateBy(user.getId());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customerMapper.insertCustomer(customer);
        }
        //封装联系人实体类
        Contacts contacts = new Contacts();
        contacts.setId((String) map.get("id"));
        contacts.setOwner(user.getId());
        contacts.setSource((String) map.get("source"));
        contacts.setCustomer(customer.getId());
        contacts.setFullname((String) map.get("fullname"));
        contacts.setAppellation((String) map.get("appellation"));
        contacts.setEmail((String) map.get("email"));
        contacts.setMphone((String) map.get("mphone"));
        contacts.setJob((String) map.get("job"));
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateFormat.formatDateTime(new Date()));
        contacts.setDescription((String) map.get("description"));
        contacts.setContactSummary((String) map.get("contactSummary"));
        contacts.setNextContactTime((String) map.get("nextContactTime"));
        contacts.setAddress((String) map.get("address"));
        contactsMapper.updateContactById(contacts);
    }

    /**
     * 查询 分页 by 条件
     * @param pageInfo
     * @return
     */
    @Override
    public List<Contacts> queryForPageByCondition(Map<String, Object> pageInfo) {
        return contactsMapper.selectContactsForPageByCondition(pageInfo);
    }
    //条件查询的总条数
    @Override
    public int queryCountByCondition(Map<String, Object> pageInfo) {
        return contactsMapper.selectCountByCondition(pageInfo);
    }
    //查询多条 用于备注页面展示 通过客户id
    @Override
    public List<Contacts> queryForRemarkPageByCustomerId(String customerId) {
        return contactsMapper.selectContactsForRemarkPageByCustomerId(customerId);
    }
    //查询所有 精细查询
    @Override
    public List<Contacts> queryAllForDetail() {
        return contactsMapper.selectAllForDetail();
    }
    //精细查询单条
    @Override
    public Contacts queryOneForDetail(String id) {
        return contactsMapper.selectOneByIdForDetail(id);
    }
    //快速查询单条
    @Override
    public Contacts queryOneById(String id) {
        Contacts contacts = contactsMapper.selectOneByIdContacts(id);
        Customer customer = customerMapper.selectOneByIdCustomer(contacts.getCustomer());
        if (customer != null) {
            contacts.setCustomer(customer.getName());
        }else {
            contacts.setCustomer(null);
        }
        return contacts;
    }
}
