package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.workbench.domain.ActivityRemark;
import com.mycode.crm.workbench.service.ActivitiesRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivitiesRemarkController {

    @Autowired
    private ActivitiesRemarkService activitiesRemarkService;

    /**
     * 保存市场活动备注
     * @param activityRemark
     * @param session
     * @return json数据提供前台渲染页面
     */
    @RequestMapping("/workbench/activity/saveActivityRemark.do")
    public @ResponseBody Object saveActivityRemark(ActivityRemark activityRemark, HttpSession session){
        ReturnInfo returnInfo = new ReturnInfo();//创建响应信息实体类
        try {
            activityRemark.setId(UUIDUtil.getUUID());//设置id
            activityRemark.setCreateTime(DateFormat.formatDate(new Date()));//设置创建日期
            User user = (User) session.getAttribute(Constants.SESSION_USER_KEY);
            activityRemark.setCreateBy(user.getId());//设置当前登录用户id
            activityRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_NOEDIT);//设置是否更改过
            int count = activitiesRemarkService.saveActivityRemark(activityRemark);

            System.out.println(count);
            if (count != 1) {
                returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
                returnInfo.setMessage("系统忙，请稍后重试~");
            }else{
                returnInfo.setCode(Constants.RESPONSE_CODE_SUCCESS);
                returnInfo.setData(activityRemark);//设置响应数据实体类
            }
        }catch (Exception e){
            returnInfo.setCode(Constants.RESPONSE_CODE_ERROR);
            returnInfo.setMessage("系统忙，请稍后重试~");
            e.printStackTrace();
        }
        return returnInfo;
    }

}
