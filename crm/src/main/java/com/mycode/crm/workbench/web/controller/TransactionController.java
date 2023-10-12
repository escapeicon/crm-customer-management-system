package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.mapper.UserMapper;
import com.mycode.crm.settings.service.DicValueService;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.domain.Contacts;
import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.domain.Transaction;
import com.mycode.crm.workbench.service.ActivitiesService;
import com.mycode.crm.workbench.service.ContactsService;
import com.mycode.crm.workbench.service.CustomerService;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

@Controller
public class TransactionController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivitiesService activitiesService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;

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

    /**
     * 前往交易创建页面
     * @param request
     * @return
     */
    @RequestMapping("/workbench/transaction/toTransactionSavePage.do")
    public String toTransactionSavePage(HttpServletRequest request){

        //所有者
        List<User> users = userService.queryAllUsers();
        //阶段
        List<DicValue> stages = dicValueService.queryDicValueByTypeCode("stage");
        //类型
        List<DicValue> types = dicValueService.queryDicValueByTypeCode("transactionType");
        //来源
        List<DicValue> sources = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("users",users);
        request.setAttribute("stages",stages);
        request.setAttribute("types",types);
        request.setAttribute("sources",sources);

        return "workbench/transaction/save";
    }

    /**
     * 获取所有市场活动 用于市场活动源
     * @return
     */
    @RequestMapping("/workbench/transaction/getAllActivities.do")
    public @ResponseBody Object getAllActivities(){
        HashMap<String, Object> returnInfo = new HashMap<>();
        //市场活动 名称 开始日期 结果日期 所有者
        List<Activity> activities = activitiesService.queryAllActivities();
        returnInfo.put("activities",activities);
        return returnInfo;
    }

    /**
     * 获取所有联系人 用于联系人源
     * @return
     */
    @RequestMapping("/workbench/transaction/getAllContacts.do")
    public @ResponseBody Object getAllContacts(){
        HashMap<String, Object> returnInfo = new HashMap<>();
        //联系人 名称 邮箱 手机
        List<Contacts> contacts = contactsService.queryAllForDetail();
        returnInfo.put("contacts",contacts);
        return returnInfo;
    }

    /**
     * 阶段 可行性分析
     * @param stage
     * @return
     */
    @RequestMapping("/workbench/transaction/stageAnalyse.do")
    public @ResponseBody Object stageAnalyse(String stage){
        ReturnInfo returnInfo = new ReturnInfo();
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String progress = possibility.getString(stage);
        returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        returnInfo.setData(progress);
        return returnInfo;
    }

    /**
     * 获取所有客户 用于自动补全插件
     * @return
     */
    @RequestMapping("/workbench/transaction/getCustomerByName.do")
    public @ResponseBody Object getCustomerByName(String customerName){
        ReturnInfo returnInfo = new ReturnInfo();
        List<Customer> customers = customerService.queryCustomerListByName(customerName);
        if (customers != null) {
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            returnInfo.setData(customers);
        }
        return returnInfo;
    }

    /**
     * 保存交易
     * @param map
     * @param session
     * @return
     */
    @RequestMapping("/workbench/transaction/saveCreateTransaction.do")
    public @ResponseBody Object saveCreateTransation(@RequestParam Map<String,Object> map, HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            map.put("user",user);

            transactionService.saveTransaction(map);
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            returnInfo.setMessage("创建交易成功~");
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 跳转交易修改页面
     * @param transactionId
     * @return
     */
    @RequestMapping("/workbench/transaction/toEditTransaction.do")
    public String toEditTransaction(String transactionId,HttpServletRequest request){
        Transaction transaction = transactionService.queryOneByIdForSimple(transactionId);

        //获取交易的客户name
        String customerId = transaction.getCustomerId();
        if (customerId != null && !("".equals(customerId))) {
            Customer customer = customerService.queryOneById(customerId);
            transaction.setCustomerId(customer.getName());
        }
        //获取市场活动名
        String activityId = transaction.getActivityId();
        if (activityId != null) {
            Activity activity = activitiesService.queryActivityById(activityId);
            transaction.setActivityId(activity.getName());
        }
        //获取联系人名
        String contactsId = transaction.getContactsId();
        if (contactsId != null) {
            Contacts contacts = contactsService.queryOneById(contactsId);
            transaction.setContactsId(contacts.getFullname());
        }

        request.setAttribute("transaction",transaction);
        //所有者
        List<User> users = userService.queryAllUsers();
        //阶段
        List<DicValue> stages = dicValueService.queryDicValueByTypeCode("stage");
        //类型
        List<DicValue> types = dicValueService.queryDicValueByTypeCode("transactionType");
        //来源
        List<DicValue> sources = dicValueService.queryDicValueByTypeCode("source");
        request.setAttribute("users",users);
        request.setAttribute("stages",stages);
        request.setAttribute("types",types);
        request.setAttribute("sources",sources);
        return "workbench/transaction/edit";
    }

    /**
     * 保存已修改的交易
     * @param transaction
     * @return
     */
    @RequestMapping("/workbench/transaction/updateTransaction.do")
    public @ResponseBody Object updateTransaction(Transaction transaction,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            HashMap<String, Object> map = new HashMap<>();

            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            map.put("user",user);
            map.put("transaction",transaction);
            transactionService.updateTransactionById(map);
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 删除交易
     * @param ids
     * @return
     */
    @RequestMapping("/workbench/transaction/deleteTransaction.do")
    public @ResponseBody Object deleteTransaction(String[] ids){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            transactionService.deleteTransactionByIds(ids);
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }
}
