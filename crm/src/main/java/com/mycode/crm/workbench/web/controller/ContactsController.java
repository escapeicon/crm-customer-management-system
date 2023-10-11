package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.DicValueService;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Contacts;
import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.service.ContactsService;
import com.mycode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactsController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;

    /**
     * 跳转 联系人主页
     * @param request
     * @return
     */
    @RequestMapping("/workbench/contacts/index.do")
    public String toContactsIndex(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();//获取所有用户
        List<DicValue> sources = dicValueService.queryDicValueByTypeCode("source");//获取所有来源
        List<DicValue> appellations = dicValueService.queryDicValueByTypeCode("appellation");//获取所有来源

        request.setAttribute("users",users);
        request.setAttribute("sources",sources);
        request.setAttribute("appellations",appellations);
        return "workbench/contacts/index";
    }

    /**
     * 分页查询 条件查询
     * @param owner
     * @param fullname
     * @param customer
     * @param source
     * @param pageNo
     * @param pageSize
     * @param session
     * @return
     */
    @RequestMapping("/workbench/contacts/queryForPageByCondition.do")
    public @ResponseBody Object queryForPageByCondition(
            String owner,String fullname,String customer,String source,int pageNo,int pageSize,
            HttpSession session
    ){
        //封装请求参数
        HashMap<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("owner",owner);
        pageInfo.put("fullname",fullname);
        pageInfo.put("customer",customer);
        pageInfo.put("source",source);
        pageInfo.put("beginNo",(pageNo - 1) * pageSize);
        pageInfo.put("pageSize",pageSize);

        List<Contacts> contacts = contactsService.queryForPageByCondition(pageInfo);//联系人结果集
        int totalRows = contactsService.queryCountByCondition(pageInfo);//联系人结果集总条数

        //对联系人进行判空
        if (contacts != null) {
            //封装结果集
            Map<String, Object> returnInfo = new HashMap<>();

            returnInfo.put("contacts",contacts);
            returnInfo.put("totalRows",totalRows);

            //存储页码
            session.setAttribute(Constants.CONTACTS_PAGE_NO,pageNo);
            session.setAttribute(Constants.CONTACTS_PAGE_SIZE,pageSize);

            return returnInfo;
        }
        return null;
    }

    /**
     * 创建联系人
     * @param map
     * @param session
     * @return
     */
    @RequestMapping("/workbench/contacts/addOneContact.do")
    public @ResponseBody Object addOneContact(@RequestBody Map<String,Object> map, HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            Object user = session.getAttribute(Constants.SESSION_USER_KEY);
            map.put("user",user);

            contactsService.saveContactForManual(map);
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 为创建和修改模态窗口提供客户名称
     * @param name
     * @return
     */
    @RequestMapping("/workbench/contacts/getCustomerListForCreateAndEdit.do")
    public @ResponseBody Object getCustomerListForCreateAndEdit(String name){
        List<Customer> customers = customerService.queryCustomerListByName(name);//获取客户模糊查询的客户名集合
        return customers;
    }

    /**
     * 删除联系人 根据id数组
     * @param ids
     * @return
     */
    @RequestMapping("/workbench/contacts/deleteContacts.do")
    public @ResponseBody Object deleteContacts(String[] ids){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            int count = contactsService.deleteContactByIds(ids);

            if (count > 0) {
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
     * 加载修改页面 联系人信息
     * @param id
     * @return
     */
    @RequestMapping("/workbench/contacts/loadEditPage.do")
    public @ResponseBody Object loadEditPage(String id){
        Contacts contacts = contactsService.queryOneById(id);
        return contacts;
    }

    /**
     * 保存用户已修改的联系人信息
     * @param map
     * @return
     */
    @RequestMapping("/workbench/contacts/saveEditContact.do")
    public @ResponseBody Object saveEditContact(@RequestBody Map<String,Object> map,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            Object user = session.getAttribute(Constants.SESSION_USER_KEY);
            map.put("user",user);
            contactsService.updateContactById(map);
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试....");
            e.printStackTrace();
        }
        return returnInfo;
    }
}
