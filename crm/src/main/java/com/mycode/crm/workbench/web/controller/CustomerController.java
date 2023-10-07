package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Customer;
import com.mycode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;

    /**
     * 跳转客户主页
     * @param request
     * @return
     */
    @RequestMapping("/workbench/customer/index.do")
    public String toCustomerIndex(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();
        request.setAttribute("users",users);
        return "workbench/customer/index";
    }


    @RequestMapping("/workbench/customer/queryForPageByCondition.do")
    public @ResponseBody Object queryForPageByCondition(String name, String owner, String phone, String website, int pageNo, int pageSize,HttpSession session){
        try {
            //封装map集合
            HashMap<String, Object> pageInfo = new HashMap<>();
            pageInfo.put("name",name);
            pageInfo.put("owner",owner);
            pageInfo.put("phone",phone);
            pageInfo.put("website",website);
            pageInfo.put("beginNo",(pageNo - 1) * pageSize);
            pageInfo.put("pageSize",pageSize);

            List<Customer> customers = customerService.queryCustomerForPageByCondition(pageInfo);
            int totalRows = customerService.queryCountCustomerForPageByCondition(pageInfo);

            if (customers != null) {
                //封装返回实体类map集合
                Map<String, Object> returnInfo = new HashMap<>();
                returnInfo.put("customers",customers);
                returnInfo.put("totalRows",totalRows);

                //客户页面 pageNo and pageSize
                session.setAttribute(Constants.CUSTOMER_PAGE_NO,pageNo);
                session.setAttribute(Constants.ACTIVITY_PAGE_SIZE,pageSize);

                return returnInfo;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}
