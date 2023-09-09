package com.mycode.crm.settings.web.controller;

import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String login(String loginAct,String loginPwd,String isRemPwd){
        Map<String, Object> loginInfo = new HashMap<>();

        loginInfo.put("loginAct","ls");
        loginInfo.put("loginPwd","yf123");

        User user = userService.queryUserByLoginActAndPwd(loginInfo);

        System.out.println("到达此处");
        return "settings/qx/user/login";
    }
}
