package com.mycode.crm.settings.web.interceptor;

import com.mycode.crm.settings.domain.User;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        //获取session对象
        HttpSession session = request.getSession();
        //获取session作用域中的userInfo信息
        User userInfo = (User) session.getAttribute("userInfo");
        if (userInfo == null) {
            //等于null说明这次请求并未登陆，需要跳转到登录页面
            response.sendRedirect(request.getContextPath());
            return false;
        }
        //程序能走到这说明通过了拦截器的拦截规则，准许放行即可
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
