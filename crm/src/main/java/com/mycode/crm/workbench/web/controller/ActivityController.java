package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    /**
     * 跳转至市场活动页面控制器方法
     * @return
     */
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法获取所有用户信息
        List<User> users = userService.queryAllUsers();

        //向request作用域中添加查询到的所有用户信息
        request.setAttribute("users",users);

        return "workbench/activity/index";
    }


}
