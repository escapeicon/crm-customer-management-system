package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.workbench.domain.*;
import com.mycode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Controller
public class ContactDetailController {

    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivitiesService activitiesService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;

    /**
     * 跳转至联系人备注页
     * @param contactId
     * @return
     */
    @RequestMapping("/workbench/contacts/toContactDetailPage.do")
    public String toContactDetailPage(String contactId, HttpServletRequest request){

        //联系人
        Contacts contact = contactsService.queryOneForDetail(contactId);
        //联系人备注
        List<ContactsRemark> contactsRemarks = contactsRemarkService.queryContactsRemarkByContactId(contactId);
        //交易
        List<Transaction> transactions = transactionService.queryForRemarkPageByContactId(contactId);
        //关联市场活动
        List<Activity> activities = activitiesService.queryActivitiesForContactRelationByContactId(contactId);

        request.setAttribute("contact",contact);
        request.setAttribute("contactsRemarks",contactsRemarks);
        request.setAttribute("transactions",transactions);
        request.setAttribute("activities",activities);
        return "/workbench/contacts/detail";
    }

    /**
     * 保存联系人备注
     * @param noteContent
     * @param session
     * @return
     */
    @RequestMapping("/workbench/contacts/saveContactRemark.do")
    public @ResponseBody Object saveContactRemark(String noteContent, String contactId,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);

            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setContactsId(contactId);
            contactsRemark.setEditFlag("0");
            contactsRemark.setCreateTime(DateFormat.formatDateTime(new Date()));
            contactsRemark.setCreateBy(user.getId());
            int count = contactsRemarkService.saveContactsRemark(contactsRemark);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(contactsRemark);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            throw new RuntimeException(e);
        }
        return returnInfo;
    }

    /**
     * 加载联系人备注信息
     * @param contactRemarkId
     * @return
     */
    @RequestMapping("/workbench/contacts/loadEditContactRemark.do")
    public @ResponseBody Object loadEditContactRemark(String contactRemarkId){
        return contactsRemarkService.queryOneById(contactRemarkId);
    }

    /**
     * 修改联系人备注
     * @param contactsRemark
     * @return
     */
    @RequestMapping("/workbench/contacts/saveEditedContactRemark.do")
    public @ResponseBody Object saveEditedContactRemark(ContactsRemark contactsRemark,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            contactsRemark.setEditBy(user.getId());
            contactsRemark.setEditTime(DateFormat.formatDateTime(new Date()));
            contactsRemark.setEditFlag("1");

            int count = contactsRemarkService.updateContactsRemarkById(contactsRemark);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(contactsRemark);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            throw new RuntimeException(e);
        }
        return returnInfo;
    }

    /**
     * 删除联系人备注 根据id
     * @param id
     * @return
     */
    @RequestMapping("/workbench/contacts/deleteContactsRemark.do")
    public @ResponseBody Object deleteContactsRemark(String id){
        ReturnInfo returnInfo = new ReturnInfo();
        int count = contactsRemarkService.deleteContactsRemarkById(id);
        if (count>0) {
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        }else {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
        }
        return returnInfo;
    }

    /**
     * 删除交易 根据交易id
     * @param transactionId
     * @return
     */
    @RequestMapping("/workbench/contacts/deleteTransactionById.do")
    public @ResponseBody Object deleteTransactionById(String transactionId){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            transactionService.deleteTransactionById(transactionId);
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            throw new RuntimeException(e);
        }
        return returnInfo;
    }

    /**
     * 加载绑定市场活动 的所有市场活动数据
     * @param contactId
     * @return
     */
    @RequestMapping("/workbench/contacts/getAllActivitiesExcluedBundled.do")
    public @ResponseBody Object getAllActivitiesExcluedBundled(String contactId){
        ReturnInfo returnInfo = new ReturnInfo();
        List<Activity> activities = activitiesService.queryActivitiesForContactUnBundledByContactId(contactId);
        if (activities != null) {
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            returnInfo.setData(activities);
        }
        return returnInfo;
    }

    /**
     * 绑定联系人市场活动关联关系
     * @param activityIds
     * @param contactId
     * @return
     */
    @RequestMapping("/workbench/contacts/bundleContactActivity.do")
    public @ResponseBody Object bundleContactActivity(String[] activityIds,String contactId){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            //封装关联关系实体类集合
            ArrayList<ContactsActivityRelation> contactsActivityRelations = new ArrayList<>();
            Arrays.stream(activityIds).forEach(activityId -> {
                ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setActivityId(activityId);
                contactsActivityRelation.setContactsId(contactId);
                contactsActivityRelations.add(contactsActivityRelation);
            });
            int count = contactsActivityRelationService.saveContactsActivityForList(contactsActivityRelations);

            if (count>0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            throw new RuntimeException(e);
        }
        return returnInfo;
    }

    /**
     * 解绑联系人市场活动关联关系
     * @param activityId
     * @param contactId
     * @return
     */
    @RequestMapping("/workbench/contacts/unBundleContactActivity.do")
    public @ResponseBody Object unBundleContactActivity(String activityId,String contactId){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            int count = contactsActivityRelationService.deleteByContactIdAndActivityId(contactId, activityId);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙,请稍后重试...");
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 跳转至市场活动页面
     * @param activityId
     * @return
     */
    @RequestMapping("/workbench/contacts/toActivityDetail.do")
    public String toActivityDetail(String activityId){
        return "redirect:/workbench/activity/detailActivity.do?id="+activityId;
    }
}
