package com.mycode.crm.settings.web.mapper;

import com.mycode.crm.settings.web.pojo.User;
import org.springframework.stereotype.Repository;

import java.util.Map;

public interface UserMapper {

    /**
     * 根据账号和密码查询用户
     * @param loginInfo
     * @return
     */
    User selectUserByLoginActAndPwd(Map<String,String> loginInfo);

}
