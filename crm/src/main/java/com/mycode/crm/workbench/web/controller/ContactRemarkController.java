package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.domain.Contacts;
import com.mycode.crm.workbench.domain.ContactsRemark;
import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.service.ActivitiesService;
import com.mycode.crm.workbench.service.ContactsRemarkService;
import com.mycode.crm.workbench.service.ContactsService;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class ContactRemarkController {

    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivitiesService activitiesService;

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
}
