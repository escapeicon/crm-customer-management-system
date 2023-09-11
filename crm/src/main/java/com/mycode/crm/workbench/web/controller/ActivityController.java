package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.ResponseInfo;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.MarketingActivities;
import com.mycode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;

    /**
     * 跳转至市场活动页面控制器方法
     * @return
     */
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法获取所有用户信息
        List<User> users = userService.queryAllUsers();
        //向request作用域中添加查询到的所有用户信息
        request.setAttribute("users",users);
        return "workbench/activity/index";
    }

    /**
     * 保存市场活动控制器方法
     * @return json数据
     */
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(String owner,String name,String startTime,String endTime,String cost,String describe){
        //生成市场活动的id
        String uuid = UUID.randomUUID().toString().replaceAll("-","");
        //生成当前时间作为创建的时间
        String nowTime = DateFormat.formatDateTime(new Date());
        //创建市场活动实体类
        MarketingActivities activity = new MarketingActivities(uuid, owner, name, startTime, endTime, cost, describe, nowTime, owner, null, null);

        //调用业务层
        int count = activityService.create(activity);

        //创建响应实体类
        ReturnInfo returnInfo = new ReturnInfo();

        if (count == 1) {
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_SUCCESS);
        }else {
            returnInfo.setCode(ResponseInfo.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("添加失败!");
        }

        return returnInfo;
    }

}
