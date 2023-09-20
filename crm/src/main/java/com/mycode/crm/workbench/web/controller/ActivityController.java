package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.GenerateExcelFile;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.service.ActivityService;
import com.sun.tools.internal.jxc.ap.Const;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
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

    /**
     * 根据市场活动id删除市场活动
     * @param id
     * @return json
     */
    @RequestMapping("/workbench/activity/deleteActivityById.do")
    public @ResponseBody Object deleteActivityById(String[] id){
        ReturnInfo returnInfo = new ReturnInfo();

        try{
            int count = activityService.deleteActivityByIds(id);//调用service层删除条数，返回更新条数
            if (count > 0) {
                returnInfo.setMessage("删除成功!");
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else{
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试");
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试");
            e.printStackTrace();
        }

        return returnInfo;
    }

    /**
     * 获取市场活动信息用来展示修改页面
     * @param id 市场活动id
     * @return 市场活动信息
     */
    @RequestMapping("/workbench/activity/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        return activityService.queryActivityById(id);
    }

    /**
     * 根据id修改市场活动信息
     * @param activity 市场活动实体类
     * @return 更新数据库记录条数
     */
    @RequestMapping("/workbench/activity/modifyActivityById.do")
    public @ResponseBody Object modifyActivityById(Activity activity,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();

        //创建修改时间
        String editTime = DateFormat.formatDateTime(new Date());
        //获取当前修改用户id
        User userInfo = (User) session.getAttribute(Constants.SESSION_USER_KEY);
        String editBy = userInfo.getId();

        //修改activity实体属性
        activity.setEditBy(editBy);
        activity.setEditTime(editTime);

        try{
            int count = activityService.saveEditActivity(activity);//调用业务层进行修改
            if (count>0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setMessage("修改成功");
            }else{
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试!");
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试!");
            e.printStackTrace();
        }

        return returnInfo;
    }

    /**
     * 提供用户下载所有市场活动excel表
     * @return 所有市场活动的excel表
     */
    @RequestMapping("/workbench/activity/downloadAllActivities.do")
    public ResponseEntity<byte[]> downloadExcel(){
        List<Activity> activities = activityService.queryAllActivities();//获取所有activity条数

        try {
            GenerateExcelFile.generateFile("市场活动信息",Activity.class,activities,"E:\\86523\\Desktop\\activities.xls");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return null;
    }
}
