package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.mapper.UserMapper;
import com.mycode.crm.settings.service.DicValueService;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;

@Controller
public class TransactionController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private TransactionService transactionService;

    /**
     * 跳转主页
     * @param request
     * @return
     */
    @RequestMapping("/workbench/transaction/index.do")
    public String toTransactionIndex(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();//获取user集合
        List<DicValue> stages = dicValueService.queryDicValueByTypeCode("stage");//查询阶段
        List<DicValue> types = dicValueService.queryDicValueByTypeCode("transactionType");//查询类型
        List<DicValue> sources = dicValueService.queryDicValueByTypeCode("source");//查询来源

        //给request传递参数
        request.setAttribute(Constants.SESSION_USER_KEY,users);
        request.setAttribute("stages",stages);
        request.setAttribute("types",types);
        request.setAttribute("sources",sources);
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/queryForPageByCondition.do")
    public @ResponseBody Object queryForPageByCondition(
            String owner,String name,String customerId,String stage,String type,String source,String contactsId,
            int pageNo,int pageSize,
            HttpSession session
    ){
        //封装页面信息
        HashMap<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("owner",owner);
        pageInfo.put("name",name);
        pageInfo.put("customerId",customerId);
        pageInfo.put("stage",stage);
        pageInfo.put("type",type);
        pageInfo.put("source",source);
        pageInfo.put("contactsId",contactsId);
        pageInfo.put("beginNo",(pageNo - 1) * pageSize);
        pageInfo.put("pageSize",pageSize);

        //查询所有交易 && 交易条数
        List<Transaction> transactions = transactionService.queryForPageByCondition(pageInfo);
        int totalRows = transactionService.queryCountByCondition(pageInfo);

        if (transactions != null) {
            //封装返回数据
            HashMap<String, Object> returnInfo = new HashMap<>();
            returnInfo.put("transactions",transactions);
            returnInfo.put("totalRows",totalRows);

            //存储页码
            session.setAttribute(Constants.TRANSACTION_PAGE_NO,pageNo);
            session.setAttribute(Constants.TRANSACTION_PAGE_SIZE,pageSize);
            return returnInfo;
        }
        return null;
    }
}
