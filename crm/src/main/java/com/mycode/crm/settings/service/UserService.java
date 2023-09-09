package com.mycode.crm.settings.service;

import com.mycode.crm.settings.domain.User;

import java.util.Map;
import java.util.Objects;

public interface UserService {
    User queryUserByLoginActAndPwd(Map<String, Object> loginInfo);
}
