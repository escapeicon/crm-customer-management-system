package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.mapper.DicValueMapper;
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
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private DicValueMapper dicValueMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

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
        String isCreateTran = (String) data.get("isCreateTran");//获取用户是否点击了创建交易选项

        Clue clue = clueMapper.selectClueById(clueId);//查询该条线索
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkByClueId(clueId);//查询该clueId下所有备注
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectClueActivityRelationListByClueId(clueId);//查询所有线索市场活动关联关系
        DicValue dicValue = dicValueMapper.selectDicValueByValue("新业务");//获取类型实体类

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

        //封装联系人实体类
        Contacts contacts = new Contacts();
        String contactsId = UUIDUtil.getUUID();
        contacts.setId(contactsId);
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomer(customerId);
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

        customerMapper.insertCustomer(customer);//保存客户实体类
        contactsMapper.insertContact(contacts);//保存联系人实体类

        //转换备注列表类
        if (clueRemarks.size() > 0 && clueRemarks != null) {
            List<CustomerRemark> customerRemarks = new ArrayList<>();
            List<ContactsRemark> contactsRemarks = new ArrayList<>();
            clueRemarks.forEach(clueRemark -> {
                CustomerRemark customerRemark = new CustomerRemark();
                ContactsRemark contactsRemark = new ContactsRemark();

                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setCustomerId(customerId);

                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setContactsId(contactsId);
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());

                customerRemarks.add(customerRemark);
                contactsRemarks.add(contactsRemark);
            });
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarks);//备注表 备份客户表一份
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarks);//备注表 备份联系人一份
        }

        //转换 线索市场活动 -> 联系人市场活动
        if (clueActivityRelations.size() > 0 && clueActivityRelations != null) {
            ArrayList<ContactsActivityRelation> contactsActivityRelations = new ArrayList<>();
            clueActivityRelations.forEach(clueActivityRelation -> {
                ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setContactsId(contactsId);
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelations.add(contactsActivityRelation);
            });
            contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelations);//关系表
        }

        //如果用户创建了交易
        if ("true".equals(isCreateTran)) {
            String money = (String) data.get("money");
            String name = (String) data.get("name");
            String expectedDate = (String) data.get("expectedDate");
            String stage = (String) data.get("stage");
            String activityId = (String) data.get("activityId");

            Transaction transaction = new Transaction();
            String transactionId = UUIDUtil.getUUID();
            transaction.setId(transactionId);
            transaction.setOwner(user.getId());
            transaction.setMoney(money);
            transaction.setName(name);
            transaction.setExpectedDate(expectedDate);
            transaction.setCustomerId(customerId);
            transaction.setStage(stage);
            transaction.setType(dicValue.getId());
            transaction.setSource(clue.getSource());
            transaction.setActivityId(activityId);
            transaction.setContactsId(contactsId);
            transaction.setCreateBy(user.getId());
            transaction.setCreateTime(DateFormat.formatDateTime(new Date()));
            transaction.setDescription(clue.getDescription());
            transaction.setContactSummary(clue.getContactSummary());
            transaction.setNextContactTime(clue.getNextContactTime());

            transactionMapper.insertTransaction(transaction);

            //转换线索备注 -> 交易备注
            if (clueRemarks.size() > 0 && clueRemarks != null){
                ArrayList<TransactionRemark> transactionRemarks = new ArrayList<>();

                clueRemarks.forEach(clueRemark -> {
                    TransactionRemark transactionRemark = new TransactionRemark();
                    transactionRemark.setId(UUIDUtil.getUUID());
                    transactionRemark.setNoteContent(clueRemark.getNoteContent());
                    transactionRemark.setCreateBy(clueRemark.getCreateBy());
                    transactionRemark.setCreateTime(clueRemark.getCreateTime());
                    transactionRemark.setEditBy(clueRemark.getEditBy());
                    transactionRemark.setEditTime(clueRemark.getEditTime());
                    transactionRemark.setEditFlag(clueRemark.getEditFlag());
                    transactionRemark.setTransactionId(transactionId);

                    transactionRemarks.add(transactionRemark);
                });

                transactionRemarkMapper.insertTransactionRemarkByList(transactionRemarks);
            }
        }

        //删除该线索下所有备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        //删除该线索和市场活动关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        //删除该线索
        clueMapper.deleteById(clueId);
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
