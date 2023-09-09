package com.mycode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkbenchIndexController {

    @RequestMapping("/settings/qx/index.do")
    public String index(){
        return "workbench/index";
    }
}
