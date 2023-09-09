package com.mycode.crm.settings.web.service;

import com.mycode.crm.settings.web.pojo.User;
import org.junit.Test;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


public class TestService {

    @Test
    public void testLogin() throws IOException {
        UserService userService = new UserService();
        Map<String, String> loginInfo = new HashMap<>();

        loginInfo.put("loginAct","ls");
        loginInfo.put("loginPwd","yf123");

        User user = userService.queryUserByLoginActAndPwd(loginInfo);

        System.out.println(user);
    }
}
