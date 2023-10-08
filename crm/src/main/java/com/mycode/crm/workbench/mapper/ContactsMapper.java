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
     * 查询 多条联系人 分页查询 根据条件
     * @param pageInfo
     * @return
     */
    List<Contacts> selectContactsForPageByCondition(Map<String,Object> pageInfo);
    //查询分页条件查询结果的总条数
    int selectCountByCondition(Map<String,Object> pageInfo);
}