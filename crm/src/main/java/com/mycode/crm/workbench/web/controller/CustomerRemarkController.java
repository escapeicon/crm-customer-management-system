package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
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
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
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

    /**
     * 保存客户备注
     * @param noteContent
     * @param session
     * @return
     */
    @RequestMapping("/workbench/customer/addCustomerRemark.do")
    public @ResponseBody Object addCustomerRemark(String noteContent,String customerId, HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);

            //封装客户备注实体类
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCreateBy(user.getId());
            customerRemark.setCreateTime(DateFormat.formatDateTime(new Date()));
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customerId);

            int count = customerRemarkService.saveCustomerRemark(customerRemark);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(customerRemark);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 查询要修改的客户备注信息
     * @param id
     * @return
     */
    @RequestMapping("/workbench/customer/editCustomerRemark.do")
    public @ResponseBody Object editCustomerRemark(String id){
        CustomerRemark customerRemark = customerRemarkService.queryCustomerRemarkForDetailById(id);
        return customerRemark;
    }

    /**
     * 保存已修改的客户备注信息
     * @param customerRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/customer/saveEditedCustomerRemark.do")
    public @ResponseBody Object saveEditedCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            customerRemark.setEditBy(user.getId());
            customerRemark.setEditTime(DateFormat.formatDateTime(new Date()));
            customerRemark.setEditFlag("1");

            int count = customerRemarkService.updateCustomerRemark(customerRemark);

            if (count > 0) {
                returnInfo.setCode(Constants.REMARK_EDIT_FLAG_EDITED);
                returnInfo.setData(customerRemark);
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
     * 删除客户备注 根据id
     * @param id
     * @return
     */
    @RequestMapping("/workbench/customer/deleteCustomerRemark.do")
    public @ResponseBody Object deleteCustomerRemark(String id){
        ReturnInfo returnInfo = new ReturnInfo();
        int count = customerRemarkService.deleteCustomerRemarkById(id);
        if (count>0) {
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        }else {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
        }
        return returnInfo;
    }

    /**
     * 删除交易 根据id
     * @param id
     * @return
     */
    @RequestMapping("/workbench/customer/deleteTransaction.do")
    public @ResponseBody Object deleteTransaction(String id){
        return null;
    }
}
