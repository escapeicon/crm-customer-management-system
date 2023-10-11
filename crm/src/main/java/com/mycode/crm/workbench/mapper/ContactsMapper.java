package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {

    /**
     * 新增联系人
     * @param contacts
     * @return
     */
    int insertContact(Contacts contacts);

    /**
     * 删除联系人 根据id数组
     * @param ids
     * @return 数据库更新条数
     */
    int deleteContactByIds(String[] ids);
    //删除联系人 根据id
    int deleteContactById(String id);

    /**
     * 修改联系人 根据id
     * @param contacts
     * @return
     */
    int updateContactById(Contacts contacts);

    /**
     * 查询 多条联系人 分页查询 根据条件
     * @param pageInfo
     * @return
     */
    List<Contacts> selectContactsForPageByCondition(Map<String,Object> pageInfo);
    //查询分页条件查询结果的总条数
    int selectCountByCondition(Map<String,Object> pageInfo);
    //查询 多条联系人 用于备注页面展示 根据客户id
    List<Contacts> selectContactsForRemarkPageByCustomerId(String customerId);
    //查询所有 精细查询
    List<Contacts> selectAllForDetail();
    //精细查询单条 根据id
    Contacts selectOneByIdForDetail(String id);
    //快速查询单条 根据id
    Contacts selectOneByIdContacts(String id);
}