package com.mycode.crm.settings.web.service;

import com.mycode.crm.settings.web.mapper.UserMapper;
import com.mycode.crm.settings.web.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;

    public User queryUserByLoginActAndPwd(Map<String,String> loginInfo){
        return userMapper.selectUserByLoginActAndPwd(loginInfo);
    }
}
