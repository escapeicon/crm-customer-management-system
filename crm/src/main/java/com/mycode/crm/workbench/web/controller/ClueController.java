package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.DicValueService;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.domain.Clue;
import com.mycode.crm.workbench.domain.ClueActivityRelation;
import com.mycode.crm.workbench.domain.ClueRemark;
import com.mycode.crm.workbench.service.ActivitiesService;
import com.mycode.crm.workbench.service.ClueActivityRelationService;
import com.mycode.crm.workbench.service.ClueRemarkService;
import com.mycode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivitiesService activitiesService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    /**
     * 跳转线索首页
     * @return
     */
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        try {
            List<User> users = userService.queryAllUsers();//查询所有用户
            List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");//查询所有称呼
            List<DicValue> clueState = dicValueService.queryDicValueByTypeCode("clueState");//查询所有线索状态
            List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");//查询所有线索来源

            //给请求域填充数据
            request.setAttribute("users",users);
            request.setAttribute("appellations",appellation);
            request.setAttribute("clueStates",clueState);
            request.setAttribute("sources",source);

        }catch (Exception e){
            e.printStackTrace();
        }
        return "workbench/clue/index";
    }

    /**
     * 分页查询 条件查询控制器方法
     * @param fullname
     * @param company
     * @param phone
     * @param source
     * @param owner
     * @param mphone
     * @param state
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/workbench/clue/queryCluesForPageAndForCondition.do")
    public @ResponseBody Object queryCluesForPageAndForCondition(
            String fullname,
            String company,
            String phone,
            String source,
            String owner,
            String mphone,
            String state,
            int pageNo,
            int pageSize,
            HttpSession session
    ){
        //封装参数
        HashMap<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("fullname",fullname);
        pageInfo.put("company",company);
        pageInfo.put("phone",phone);
        pageInfo.put("source",source);
        pageInfo.put("owner",owner);
        pageInfo.put("mphone",mphone);
        pageInfo.put("state",state);
        pageInfo.put("beginNo",(pageNo - 1) * pageSize);
        pageInfo.put("pageSize",pageSize);
        //调用业务层
        List<Clue> clues = clueService.queryCluesByConditionForPage(pageInfo);
        int count = clueService.queryCountCluesByConditionForPage(pageInfo);

        HashMap<String, Object> returnMap = new HashMap<>();//创建返回map集合
        returnMap.put("clues",clues);
        returnMap.put("totalRows",count);

        session.setAttribute(Constants.CLUE_PAGE_NO,pageNo);
        session.setAttribute(Constants.CLUE_PAGE_SIZE,pageSize);

        return returnMap;
    }

    /**
     * 创建线索控制器方法
     * @param clue
     * @return 响应信息
     */
    @RequestMapping("/workbench/clue/createClue.do")
    public @ResponseBody Object createClue(Clue clue, HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();//创建响应实体类
        User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);//获取当前用户
        try {
            clue.setId(UUIDUtil.getUUID());//设置id
            clue.setCreateBy(user.getId());//设置createBy
            clue.setCreateTime(DateFormat.formatDateTime(new Date()));//设置创建日期
            int count = clueService.saveClue(clue);//调用业务层保存线索方法
            if (count > 0) {
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
     * 删除线索 控制器方法
     * @param ids
     * @return 响应体实体类
     */
    @RequestMapping("/workbench/clue/deleteClue.do")
    public @ResponseBody Object deleteClue(@RequestBody String[] ids){
        ReturnInfo returnInfo = new ReturnInfo();//创建响应实体类
        try {
            int count = clueService.deleteClueByIds(ids);//调用业务层进而删除线索条数

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else{
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 渲染更新线索模态窗口控制器方法
     * @param id
     * @return 需要修改的线索的所有信息
     */
    @RequestMapping("/workbench/clue/toUpdateModal.do")
    public @ResponseBody Object toUpdateModal(String id){
        return clueService.queryClueById(id);
    }

    /**
     * 保存要更新的线索实体类
     * @param clue
     * @return returnInfo
     */
    @RequestMapping("/workbench/clue/saveUpdateClue.do")
    public @ResponseBody Object saveUpdateClue(Clue clue,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
        try{
            clue.setEditBy(user.getId());//设置修改线索的用户
            clue.setEditTime(DateFormat.formatDateTime(new Date()));//设置修改的线索的时间
            int count = clueService.updateClue(clue);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 跳转到线索明细页面控制器方法
     * @param clueId
     * @return 线索明细页面路径
     */
    @RequestMapping("/workbench/clue/toClueRemark.do")
    public String toClueRemark(String clueId,HttpServletRequest request){
        try {
            //查询数据
            Clue clue = clueService.queryClueForRemarkById(clueId);
            List<ClueRemark> clueRemarks = clueRemarkService.queryClueRemarkById(clueId);
            List<Activity> activities = activitiesService.queryActivitiesByClueIdForClueRemarkPage(clueId);
            //向域中存储数据
            request.setAttribute("clue",clue);
            request.setAttribute("clueRemarks",clueRemarks);
            request.setAttribute("activities",activities);
        }catch (Exception e){
            e.printStackTrace();
        }
        return "/workbench/clue/detail";
    }

    /**
     * 新建线索备注 控制器方法
     * @param clueRemark
     * @return 新建的线索备注实体类
     */
    @RequestMapping("/workbench/clue/saveClueRemark.do")
    public @ResponseBody Object saveClueRemark(ClueRemark clueRemark,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            //设置线索备注的其余参数
            clueRemark.setId(UUIDUtil.getUUID());
            clueRemark.setCreateBy(user.getId());
            clueRemark.setCreateTime(DateFormat.formatDateTime(new Date()));
            clueRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_NOEDIT);

            int count = clueRemarkService.saveClueRemark(clueRemark);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(clueRemark);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch(Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 删除线索备注 控制器方法
     * @param id
     * @return 响应实体类
     */
    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    public @ResponseBody Object deleteClueRemarkById(String id){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            int count = clueRemarkService.deleteClueRemarkById(id);
            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else{
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch(Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 修改线索备注 控制器方法
     * @param clueRemark
     * @return 响应实体类
     */
    @RequestMapping("/workbench/clue/updateClueRemarkById.do")
    public @ResponseBody Object updateClueRemarkById(ClueRemark clueRemark,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);//获取当前登录对象实体类
            //设置线索备注属性
            clueRemark.setEditBy(user.getId());
            clueRemark.setEditTime(DateFormat.formatDateTime(new Date()));
            clueRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_EDITED);

            int count = clueRemarkService.modifyClueRemarkById(clueRemark);

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(clueRemark);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch(Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 加载绑定市场活动列表 控制器方法
     * @return
     */
    @RequestMapping("/workbench/clue/uploadBundleList.do")
    public @ResponseBody Object uploadBundList(String clueId){
        ReturnInfo returnInfo = new ReturnInfo();
        List<Activity> activities = activitiesService.queryAllActivitiesForClueRemarkPageByClueIdExcludeBundled(clueId);
        returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        returnInfo.setData(activities);
        return returnInfo;
    }

    /**
     * 保存线索市场活动关系 控制器方法
     * @param requestData
     * @return 保存的市场活动实体类
     */
    @RequestMapping("/workbench/clue/saveClueActivityRelations.do")
    public @ResponseBody Object saveClueActivityRelations(@RequestBody Map<String,Object> requestData){
        ReturnInfo returnInfo = new ReturnInfo();
        String clueId = (String) requestData.get("clueId");//获取clueId
        List<String> activityIds = (List<String>) requestData.get("activityIds");//获取市场活动集合

        try {
            List<ClueActivityRelation> clueActivityRelations = new ArrayList<>();//创建线索市场活动关系集合
            activityIds.forEach(activityId -> {
                ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
                clueActivityRelation.setId(UUIDUtil.getUUID());//设置id
                clueActivityRelation.setClueId(clueId);//设置线索id
                clueActivityRelation.setActivityId(activityId);//设置市场活动id
                clueActivityRelations.add(clueActivityRelation);//向list集合中添加线索市场活动关系实体类
            });

            int count = clueActivityRelationService.saveClueActivityRelationByList(clueActivityRelations);//调用service层方法进而保存

            if (count > 0) {
                String[] activityIdsArray = activityIds.toArray(new String[0]);//将市场互动集合转换为数组
                List<Activity> activities = activitiesService.queryActivitiesByIds(activityIdsArray);//根据id获取市场活动集合

                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(activities);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch(Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 删除线索市场活动关系 控制器方法
     * @param clueActivityRelation
     * @return 相应实体类
     */
    @RequestMapping("/workbench/clue/deleteClueActivityRelation.do")
    public @ResponseBody Object deleteClueActivityRelation(ClueActivityRelation clueActivityRelation){
        ReturnInfo returnInfo = new ReturnInfo();
        try{
            int count = clueActivityRelationService.deleteClueActivityRelationByObject(clueActivityRelation);//调用service层进而删除

            if (count > 0) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
            }else{
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统繁忙，请稍后重试...");
            }
        }catch(Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 跳转线索转换页面 控制器方法
     * @param clueId
     * @param request
     * @return
     */
    @RequestMapping("/workbench/clue/toClueConvert.do")
    public String toClueConvert(String clueId,HttpServletRequest request){

        Clue clue = clueService.queryClueForRemarkById(clueId);//获取线索实体类
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");//获取阶段集合

        request.setAttribute("clue",clue);
        request.setAttribute("stages",stage);

        return "workbench/clue/convert";
    }

    /**
     * 线索转换 查询市场活动源
     * @return 市场活动源
     */
    @RequestMapping("/workbench/clue/convertQueryActivity.do")
    public @ResponseBody Object convertQueryActivity(String clueId){
        ReturnInfo returnInfo = new ReturnInfo();
        try {
            List<Activity> activities = activitiesService.queryActivitiesForClueConvertByClueId(clueId);//查询所有市场活动
            if (activities != null) {
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(activities);
            }else {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("无任何市场活动...");
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return returnInfo;
    }

    /**
     * 转换线索 控制器方法
     * @param data
     * @return
     */
    @RequestMapping("/workbench/clue/convertClue.do")
    public @ResponseBody Object convertClue(String clueId,String money,String name,String expectedDate, String stage,String source,String isCreateTran,HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();
        HashMap<String, Object> data = new HashMap<>();
        data.put("clueId",clueId);
        data.put("money",money);
        data.put("name",name);
        data.put("expectedDate",expectedDate);
        data.put("stage",stage);
        data.put("source",source);
        data.put("isCreateTran",isCreateTran);
        //封装当前登录用户
        User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
        data.put(Constants.SESSION_USER_KEY,user);
        try {

            clueService.saveClueConvert(data);

            returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
        } catch (Exception e) {
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统繁忙，请稍后重试...");
            throw new RuntimeException(e);
        }
        return returnInfo;
    }
}
