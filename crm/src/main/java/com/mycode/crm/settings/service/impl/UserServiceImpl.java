package com.mycode.crm.settings.service.impl;

import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.mapper.UserMapper;
import com.mycode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service(value = "userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> loginInfo) {
        return userMapper.selectUserByLoginActAndPwd(loginInfo);
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAll();
    }
}
