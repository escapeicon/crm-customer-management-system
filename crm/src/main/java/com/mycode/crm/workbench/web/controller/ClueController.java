package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
import com.mycode.crm.commons.utils.DateFormat;
import com.mycode.crm.commons.utils.UUIDUtil;
import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.domain.User;
import com.mycode.crm.settings.service.DicValueService;
import com.mycode.crm.settings.service.UserService;
import com.mycode.crm.workbench.domain.Clue;
import com.mycode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private DicValueService dicValueService;

    /**
     * 跳转线索首页
     * @return
     */
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request,String pageNo,String pageSize){
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

            if (pageNo != null && pageSize != null) {
                request.setAttribute("pageNo",pageNo);
                request.setAttribute("pageSize",pageSize);
            }

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
            int pageSize
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
            clue.setCreateTime(DateFormat.formatDate(new Date()));//设置创建日期
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
}
