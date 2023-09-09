package com.mycode.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {

    @RequestMapping("/settings/qx/user/login.html")
    public String login(){
        return "settings/qx/user/login";
    }
}
