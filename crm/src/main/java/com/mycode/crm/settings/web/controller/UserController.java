package com.mycode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String login(){
        System.out.println("到达此处");
        return "settings/qx/user/login";
    }
}
