package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Customer;
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

    /**
     * 分页条件查询
     * @param name
     * @param owner
     * @param phone
     * @param website
     * @param pageNo
     * @param pageSize
     * @param session
     * @return
     */
    @RequestMapping("/workbench/customer/queryForPageByCondition.do")
    public @ResponseBody Object queryForPageByCondition(String name, String owner, String phone, String website, int pageNo, int pageSize,HttpSession session){
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
            session.setAttribute(Constants.CUSTOMER_PAGE_SIZE,pageSize);

            return returnInfo;
        }
        return null;
    }

    /**
     * 添加客户
     * @param customer
     * @return
     */
    @RequestMapping("/workbench/customer/saveCustomer.do")
    public @ResponseBody Object saveCustomer(Customer customer,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            Customer customerByName = customerService.queryCustomerByName(customer.getName());

            if (customerByName != null) {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("客户名重复,请更改客户名");
                return returnInfo;
            }

            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);

            //补充客户实体类
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateFormat.formatDateTime(new Date()));

            int count = customerService.saveCustomer(customer);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch(Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 加载 更新页面 客户信息
     * @param id
     * @return
     */
    @RequestMapping("/workbench/customer/loadCustomer.do")
    public @ResponseBody Object loadCustomer(String id){
        ReturnInfo returnInfo = new ReturnInfo();
        Customer customer = customerService.queryOneById(id);
        if (customer != null) {
            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            returnInfo.setData(customer);
        }else{
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
        }
        return returnInfo;
    }

    /**
     * 保存用户已更改的客户实体类
     * @param customer
     * @return
     */
    @RequestMapping("/workbench/customer/saveEditedCustomer.do")
    public @ResponseBody Object saveEditedCustomer(Customer customer,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            //补充客户实体类属性
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            customer.setEditBy(user.getId());
            customer.setEditTime(DateFormat.formatDateTime(new Date()));

            //保存修改的客户
            int count = customerService.modifyCustomer(customer);
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

    /**
     * 删除客户
     * @param ids
     * @return
     */
    @RequestMapping("/workbench/customer/deleteCustomer.do")
    public @ResponseBody Object deleteCustomer(String[] ids){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            int count = customerService.deleteCustomerByIds(ids);
            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }
}
