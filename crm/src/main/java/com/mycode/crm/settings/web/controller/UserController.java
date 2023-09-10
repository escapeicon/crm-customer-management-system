package com.mycode.crm.settings.web.controller;

import com.mycode.crm.commons.constants.ResponseInfo;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 加载登录页面请求
     * @param request
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String login(HttpServletRequest request){
        return "settings/qx/user/login";
    }

    /**
     * 请求登录控制器
     * @param loginAct
     * @param loginPwd
     * @param isRemPwd
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/settings/qx/user/login.do")//路径应与响应页面一致
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){

        //创建map集合且存放用户登录信息
        Map<String, Object> loginInfo = new HashMap<>();
        loginInfo.put("loginAct",loginAct);
        loginInfo.put("loginPwd",loginPwd);

        //调用业务层获取user对象
        User user = userService.queryUserByLoginActAndPwd(loginInfo);

        //创建要返回的json对象
        ReturnInfo returnInfo = new ReturnInfo();

        //通过封装日期工具类获取用于判断用户账户是否过期的当前日期
        String nowTime = DateFormat.formatDateTime(new Date());
        //获取用户请求的ip地址
        String remoteAddr = request.getRemoteAddr();

        if (null == user) {
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("用户名或密码错误!");
        }else if (user.getExpireTime().compareTo(nowTime) < 0){
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("用户已过期!");
        } else if ("0".equals(user.getLockState())){
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("用户状态被锁定");
        } else if(!user.getAllowIps().contains(remoteAddr)){
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("用户ip受限");
        } else {
            //成功登录
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_SUCCESS);

            //在session请求域中设置用户信息,且使用常量作为session的key
            session.setAttribute(ResponseInfo.SESSION_USER_KEY,user);

            if ("true".equals(isRemPwd)){
                //用户同意十天内登录
                Cookie loginActCookie = new Cookie("loginAct", loginAct);//创建用户名cookie
                Cookie loginPwdCookie = new Cookie("loginPwd", loginPwd);//创建密码cookie
                loginActCookie.setMaxAge(60 * 60 * 24 * 10);//设置寿命为10天
                loginPwdCookie.setMaxAge(60 * 60 * 24 * 10);//设置寿命为10天
                response.addCookie(loginActCookie);//响应cookie
                response.addCookie(loginPwdCookie);//响应cookie
            }else if ("false".equals(isRemPwd)){
                //用户取消十天内登录
                Cookie loginActCookie = new Cookie("loginAct", loginAct);
                Cookie loginPwdCookie = new Cookie("loginPwd", loginPwd);
                loginActCookie.setMaxAge(0);//设置寿命为0
                loginPwdCookie.setMaxAge(0);
                response.addCookie(loginActCookie);
                response.addCookie(loginPwdCookie);
            }
        }
        return returnInfo;
    }

    /**
     * 安全退出控制层
     * @return
     */
    @RequestMapping("/settings/qx/user/toExit.do")
    public String doExit(HttpServletResponse response,HttpSession session){
        //清空cookie
        Cookie loginActCookie = new Cookie("loginAct", "1");
        Cookie loginPwdCookie = new Cookie("loginPwd", "1");
        loginActCookie.setMaxAge(0);
        loginPwdCookie.setMaxAge(0);
        response.addCookie(loginActCookie);
        response.addCookie(loginPwdCookie);
        //销毁session
        session.invalidate();
        return "redirect:/settings/qx/user/toLogin.do";
    }
}
