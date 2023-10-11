package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.workbench.domain.Contacts;
import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.domain.CustomerRemark;
import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.service.ContactsService;
import com.mycode.crm.workbench.service.CustomerRemarkService;
import com.mycode.crm.workbench.service.CustomerService;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class CustomerRemarkController {

    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TransactionService transactionService;

    /**
     * 跳转客户 详情页
     * @param request
     * @return
     */
    @RequestMapping("/workbench/customer/toCustomerRemark.do")
    public String toCustomerRemark(String customerId,HttpServletRequest request){
        try{
            //客户
            Customer customer = customerService.queryOneByIdForDetail(customerId);
            //客户备注
            List<CustomerRemark> customerRemarks = customerRemarkService.queryCustomerRemarkForListByCustomerId(customerId);
            //客户交易
            List<Transaction> transactions = transactionService.queryForRemarkPageByCustomerId(customerId);
            //客户联系人
            List<Contacts> contacts = contactsService.queryForRemarkPageByCustomerId(customerId);

            request.setAttribute("customer",customer);
            request.setAttribute("customerRemarks",customerRemarks);
            request.setAttribute("transactions",transactions);
            request.setAttribute("contacts",contacts);
        }catch (Exception e){
            e.printStackTrace();
        }
        return "workbench/customer/detail";
    }
}
