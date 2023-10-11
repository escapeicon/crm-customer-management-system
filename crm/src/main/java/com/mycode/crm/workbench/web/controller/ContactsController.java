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
import com.mycode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
     * @param contact
     * @return
     */
    @RequestMapping("/workbench/contacts/addOneContact.do")
    public @ResponseBody Object addOneContact(Contacts contact,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            //封装联系人
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            contact.setId(UUIDUtil.getUUID());
            contact.setCreateBy(user.getId());
            contact.setCreateTime(DateFormat.formatDateTime(new Date()));

            int count = contactsService.saveContact(contact);

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
