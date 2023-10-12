package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.domain.TransactionHistory;
import com.mycode.crm.workbench.domain.TransactionRemark;
import com.mycode.crm.workbench.service.TransactionHistoryService;
import com.mycode.crm.workbench.service.TransactionRemarkService;
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
public class TransactionDetailController {

    @Autowired
    private TransactionService transactionService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;

    /**
     * 跳转至交易详情页
     * @param transactionId
     * @return
     */
    @RequestMapping("/workbench/transaction/toTransactionDetail.do")
    public String toTransactionDetail(String transactionId, HttpServletRequest request){
        //获取交易
        Transaction transaction = transactionService.queryOneById(transactionId);
        //获取交易备注
        List<TransactionRemark> transactionRemarks = transactionRemarkService.queryByTransactionIdForList(transactionId);
        //获取交易历史
        List<TransactionHistory> transactionHistories = transactionHistoryService.queryByTransactionIdForList(transactionId);

        request.setAttribute("transaction",transaction);
        request.setAttribute("transactionRemarks",transactionRemarks);
        request.setAttribute("transactionHistories",transactionHistories);
        return "workbench/transaction/detail";
    }

    /**
     * 保存交易备注
     * @param transactionRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/transaction/saveTransactionRemark.do")
    public @ResponseBody Object saveTransactionRemark(TransactionRemark transactionRemark, HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);

            transactionRemark.setId(UUIDUtil.getUUID());
            transactionRemark.setCreateBy(user.getId());
            transactionRemark.setCreateTime(DateFormat.formatDateTime(new Date()));
            transactionRemark.setEditFlag("0");

            int count = transactionRemarkService.saveTransactionRemark(transactionRemark);

            if (count>0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(transactionRemark);
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
     * 获取修改交易备注信息
     * @param id
     * @return
     */
    @RequestMapping("/workbench/transaction/getUpdateTransactionRemark.do")
    public @ResponseBody Object getupdateTransactionRemark(String id) {
        return transactionRemarkService.queryOneById(id);
    }

    /**
     * 修改交易备注
     * @param transactionRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/transaction/updateTransactionRemark.do")
    public @ResponseBody Object updateTransactionRemark(TransactionRemark transactionRemark,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);

            transactionRemark.setEditFlag("1");
            transactionRemark.setEditTime(DateFormat.formatDateTime(new Date()));
            transactionRemark.setEditBy(user.getId());

            int count = transactionRemarkService.updateTransactionRemarkById(transactionRemark);
            if (count>0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(transactionRemark);
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
     * 删除交易备注
     * @param transactionRemarkId
     * @return
     */
    @RequestMapping("/workbench/transaction/deleteTransactionRemark.do")
    public @ResponseBody Object deleteTransactionRemark(String transactionRemarkId){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            int count = transactionRemarkService.deleteTransactionRemarkById(transactionRemarkId);

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

}
