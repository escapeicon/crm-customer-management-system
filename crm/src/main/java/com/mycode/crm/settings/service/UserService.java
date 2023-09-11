package com.mycode.crm.settings.service;

import com.mycode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;
import java.util.Objects;

public interface UserService {
    /**
     * 根据账户和密码查询用户
     * @param loginInfo
     * @return
     */
    User queryUserByLoginActAndPwd(Map<String, Object> loginInfo);

    /**
     * 查询所有 未被封禁 的用户
     * @return
     */
    List<User> queryAllUsers();
}
