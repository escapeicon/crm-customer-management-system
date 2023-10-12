package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.GenerateExcelFile;
import com.mycode.crm.commons.utils.HSSFUtils;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.domain.ActivityRemark;
import com.mycode.crm.workbench.service.ActivitiesRemarkService;
import com.mycode.crm.workbench.service.ActivitiesService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivitiesController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivitiesService activitiesService;//市场活动
    @Autowired
    private ActivitiesRemarkService activitiesRemarkService;//市场活动备注

    /**
     * 跳转至市场活动页面控制器方法
     * 其他页面跳转回市场活动页面需携带分页参数，否则将市场活动分页组件参数将以默认方式展现
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
            int count = activitiesService.saveCreateActivity(activity);

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
    public @ResponseBody Object queryActivityForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize,HttpSession session){
        HashMap<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("name",name);
        pageInfo.put("owner",owner);
        pageInfo.put("startDate",startDate);
        pageInfo.put("endDate",endDate);
        pageInfo.put("beginNo",(pageNo - 1) * pageSize);
        pageInfo.put("pageSize",pageSize);

        //查询数据库表信息
        List<Activity> activityList = activitiesService.queryActivityByConditionForPage(pageInfo);
        //查询表信息总条数
        int count = activitiesService.queryCountOfActivityByCondition(pageInfo);

        if (activityList != null) {
            //封装结果集
            HashMap<String, Object> retObj = new HashMap<>();
            retObj.put("activityList",activityList);
            retObj.put("totalRows",count);

            session.setAttribute(Constants.ACTIVITY_PAGE_NO,pageNo);
            session.setAttribute(Constants.ACTIVITY_PAGE_SIZE,pageSize);

            //返回结果集对象
            return retObj;
        }
        return null;
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
            int count = activitiesService.deleteActivityByIds(id);//调用service层删除条数，返回更新条数
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
        return activitiesService.queryActivityById(id);
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
            int count = activitiesService.saveEditActivity(activity);//调用业务层进行修改
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
    public void downloadAllActivities(HttpServletRequest request, HttpServletResponse response){
        try {
            response.setContentType("application/octet-stream;charset=utf-8");
            ServletOutputStream out = response.getOutputStream();//获取输出流

            List<Activity> activities = activitiesService.queryAllActivities();//获取所有activity条数
            //对获取到的市场活动列表判空
            if (activities != null) {
                String filename = "activities.xls";//设置文件名
                GenerateExcelFile generateExcelFile = new GenerateExcelFile("市场活动信息",Activity.class);//新建包装生成excel类
                HSSFWorkbook workbook = generateExcelFile.generateFileForList(activities);//创建excel文件

                //设置下载方式和文件名
                response.addHeader("Content-Disposition","attachment;filename="+filename);

                workbook.write(out);

                workbook.close();
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 导出单个对象的excel表
     * @param ids
     * @param response
     */
    @RequestMapping("/workbench/activity/downloadSingleActivity")
    public void downloadSingleActivity(@RequestBody String[] ids, HttpServletResponse response){
        try {
            response.setContentType("application/octet-stream;charset=utf-8");//设置编码格式
            ServletOutputStream out = response.getOutputStream();//获取响应输出流

            List<Activity> activities = activitiesService.queryActivitiesByIds(ids);//根据id获取市场活动对象

            GenerateExcelFile generateExcelFile = new GenerateExcelFile("市场活动表", Activity.class);//生成
            HSSFWorkbook workbook = generateExcelFile.generateFileForList(activities);

            response.addHeader("Content-Disposition","attachment;filename=activity.xls");

            workbook.write(new File("E:\\86523\\Desktop\\activities.xls"));

            workbook.write(out);

            out.flush();
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 上传excel文件导入市场活动信息
     * @param activitiesFile
     * @param session
     * @return 上传的市场活动条数
     */
    @RequestMapping("/workbench/activity/uploadActivities.do")
    public @ResponseBody Object uploadActivities(MultipartFile activitiesFile,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();//创建返回信息实体类
        try {
            InputStream inputStream = activitiesFile.getInputStream();//获取前端发送的文件载体实体类的输入流
            HSSFWorkbook workbook = new HSSFWorkbook(inputStream);//通过输入流直接创建excel文件
            HSSFSheet sheet = workbook.getSheetAt(0);//根据索引获取页面,页面下标从0开始

            //创建用于装载市场活动实体类的list集合
            ArrayList<Activity> activities = new ArrayList<>();

            int lastRowNum = sheet.getLastRowNum();//获取一页共有多少行
            //循环进行每一行数据的读取
            for(int i = 1;i <= lastRowNum;i++){//最后一行下标为2
                HSSFRow row = sheet.getRow(i);//获取行

                //创建市场活动实体类
                Activity activity = new Activity();
                //id需要后台设置
                activity.setId(UUIDUtil.getUUID());
                //owner需要设置为当前登录用户的id
                User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
                activity.setOwner(user.getId());
                //设置创建事件
                activity.setCreateTime(DateFormat.formatDateTime(new Date()));
                //设置创建用户
                activity.setCreateBy(user.getId());

                //获取一行共有多少列
                short lastCellNum = row.getLastCellNum();
                for(int j = 0; j < lastCellNum; j++){//最后一列下标+1
                    HSSFCell cell = row.getCell(j);//获取单元格
                    String value = HSSFUtils.getCellValueForString(cell);

                    System.out.println(value);

                    switch (j){
                        case 0:
                            activity.setName(value);
                            break;
                        case 1:
                            activity.setStartDate(value);
                            break;
                        case 2:
                            activity.setEndDate(value);
                            break;
                        case 3:
                            activity.setCost(value);
                            break;
                        case 4:
                            activity.setDescription(value);
                    }
                }

                System.out.println(activity);

                activities.add(activity);//给集合中添加市场活动对象
            }

            int count = activitiesService.saveActivitiesByList(activities);

            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            returnInfo.setData(count);

        } catch (IOException e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统忙碌，请稍后~");
            throw new RuntimeException(e);
        }
        return returnInfo;
    }

    /**
     * 查看市场活动明细
     * @param id 市场活动id
     * @return 市场活动信息和备注信息
     */
    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request){
        //查询市场活动信息
        Activity activity = activitiesService.queryActivityByIdForDetail(id);
        List<ActivityRemark> activityRemark = activitiesRemarkService.queryActivityRemarkForDetailById(id);
        request.setAttribute("activity",activity);//向请求域中添加市场活动信息
        request.setAttribute("activityRemarks",activityRemark);//想请求域添加市场活动备注信息
        return "workbench/activity/detail";
    }
}
