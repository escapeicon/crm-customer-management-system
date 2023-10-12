package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.domain.TransactionHistory;
import com.mycode.crm.workbench.domain.TransactionRemark;
import com.mycode.crm.workbench.service.TransactionHistoryService;
import com.mycode.crm.workbench.service.TransactionRemarkService;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
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

}
