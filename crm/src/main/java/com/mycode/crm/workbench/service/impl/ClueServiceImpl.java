package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.workbench.domain.*;
import com.mycode.crm.workbench.mapper.*;
import com.mycode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    /**
     * 创建线索
     * @param clue
     * @return 创建线索条数
     */
    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    /**
     * 保存线索转换 方法
     * @param data
     * @return
     */
    @Override
    public void saveClueConvert(Map<String,Object> data) {
        String clueId = (String) data.get("clueId");//获取线索id
        User user = (User) data.get(Constants.SESSION_USER_KEY);//获取当前登录用户

        Clue clue = clueMapper.selectClueById(clueId);//查询该条线索
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkByClueId(clueId);//查询该clueId下所有备注
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectClueActivityRelationListByClueId(clueId);//查询所有线索市场活动关联关系


        //封装客户实体类
        Customer customer = new Customer();
        String customerId = UUIDUtil.getUUID();
        customer.setId(customerId);
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(clue.getCreateBy());
        customer.setCreateTime(DateFormat.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());

        //转换备注列表类
        List<CustomerRemark> customerRemarks = new ArrayList<>();
        clueRemarks.forEach(clueRemark -> {
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(clueRemark.getCreateBy());
            customerRemark.setCreateTime(clueRemark.getCreateTime());
            customerRemark.setEditBy(clueRemark.getEditBy());
            customerRemark.setEditTime(clueRemark.getEditTime());
            customerRemark.setEditFlag(clueRemark.getEditFlag());
            customerRemark.setCustomerId(customerId);
            customerRemarks.add(customerRemark);
        });

        //封装联系人实体类
        Contacts contacts = new Contacts();
        String contactsId = UUIDUtil.getUUID();
        contacts.setId(contactsId);
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customerId);
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateFormat.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());

        //转换备注列表类
        List<ContactsRemark> contactsRemarks = new ArrayList<>();
        clueRemarks.forEach(clueRemark -> {
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(contactsId);
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(clueRemark.getCreateBy());
            contactsRemark.setCreateTime(clueRemark.getCreateTime());
            contactsRemark.setEditBy(clueRemark.getEditBy());
            contactsRemark.setEditTime(clueRemark.getEditTime());
            contactsRemark.setEditFlag(clueRemark.getEditFlag());
            contactsRemarks.add(contactsRemark);
        });

        //转换 线索市场活动 -> 联系人市场活动
        ArrayList<ContactsActivityRelation> contactsActivityRelations = new ArrayList<>();
        clueActivityRelations.forEach(clueActivityRelation -> {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contactsId);
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelations.add(contactsActivityRelation);
        });

        customerMapper.insertCustomer(customer);//保存客户实体类
        contactsMapper.insertContact(contacts);//保存联系人实体类
        customerRemarkMapper.insertCustomerRemarkByList(customerRemarks);//备注表 备份客户表一份
        contactsRemarkMapper.insertContactsRemarkByList(contactsRemarks);//备注表 备份联系人一份
        contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelations);//关系表

    }

    /**
     * 删除线索 根据id数组
     * @param ids
     * @return 删除的条数
     */
    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    /**
     * 修改线索 根据id
     * @param clue
     * @return int
     */
    @Override
    public int updateClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    /**
     * 分页查询 条件查询
     * @param pageInfo
     * @return 查询线索结果
     */
    @Override
    public List<Clue> queryCluesByConditionForPage(Map<String, Object> pageInfo) {
        return clueMapper.selectClueByConditionForPage(pageInfo);
    }
    /**
     * 分页查询结果总数
     * @param pageInfo
     * @return 总数量
     */
    @Override
    public int queryCountCluesByConditionForPage(Map<String, Object> pageInfo) {
        return clueMapper.selectCountClueByConditionForPage(pageInfo);
    }
    /**
     * 查询所有线索
     * @return 线索集合
     */
    @Override
    public List<Clue> queryAllClue() {
        return clueMapper.selectAllClue();
    }
    /**
     * 查询单条线索 根据id
     * @param id
     * @return
     */
    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    /**
     * 查询单条线索 for detail 根据id
     * @param id
     * @return
     */
    @Override
    public Clue queryClueForRemarkById(String id) {
        return clueMapper.selectClueForRemarkById(id);
    }
}
