package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

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
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        //生成市场活动的id
        activity.setId(UUIDUtil.getUUID());
        //生成当前时间作为创建的时间
        activity.setCreateTime(DateFormat.formatDateTime(new Date()));
        //获取封装在session作用域中的user对象
        User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
        //设置createBy
        activity.setCreateBy(user.getId());

        //创建响应实体类
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            //调用业务层
            int count = activityService.saveCreateActivity(activity);

            if (count == 1) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                //后端报错时返回的信息应该模糊些，不然会给使用者一种系统不健壮的错觉
                returnInfo.setMessage("系统繁忙中，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        return returnInfo;
    }

    /**
     * 分页查询数据控制器方法
     * @return json数据
     */
    @RequestMapping("/workbench/activity/queryActivityForPage.do")
    public @ResponseBody Object queryActivityForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize){
        HashMap<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("name",name);
        pageInfo.put("owner",owner);
        pageInfo.put("startDate",startDate);
        pageInfo.put("endDate",endDate);
        pageInfo.put("beginNo",(pageNo - 1) * pageSize);
        pageInfo.put("pageSize",pageSize);

        //查询数据库表信息
            List<Activity> activityList = activityService.queryActivityByConditionForPage(pageInfo);
            //查询表信息总条数
            int count = activityService.queryCountOfActivityByCondition(pageInfo);

            //封装结果集
            HashMap<String, Object> retObj = new HashMap<>();
            retObj.put("activityList",activityList);
            retObj.put("totalRows",count);

            //返回结果集对象
            return retObj;
    }
}
