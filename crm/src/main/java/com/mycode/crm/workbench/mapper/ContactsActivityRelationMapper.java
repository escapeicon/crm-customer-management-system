package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ContactsActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsActivityRelationMapper {

    /**
     * 添加多条联系人市场活动 通过list集合
     * @param contactsActivityRelationList
     * @return
     */
    int insertContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelationList);

    /**
     * 删除 联系人市场活动关联关系 通过联系人id和市场活动id
     * @param contactId
     * @param activityId
     * @return
     */
    int deleteByContactIdAndActivityId(@Param("contactId") String contactId,@Param("activityId") String activityId);
}