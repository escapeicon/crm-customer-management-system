package com.mycode.crm.workbench.web.controller;

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

import javax.servlet.http.HttpServletRequest;
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


        request.setAttribute("contact",contact);
        request.setAttribute("contactsRemarks",contactsRemarks);
        request.setAttribute("transactions",transactions);

        return "/workbench/contacts/detail";
    }

}
