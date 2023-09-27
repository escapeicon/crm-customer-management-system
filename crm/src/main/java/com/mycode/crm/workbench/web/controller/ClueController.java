package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.commons.constants.Constants;
import com.mycode.crm.commons.domain.ReturnInfo;
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

    @RequestMapping("/workbench/clue/queryCluesForPageAndForCondition.do")
    public @ResponseBody Object queryCluesForPageAndForCondition(
            String fullname,
            String company,
            String mphone,
            String source,
            String owner,
            String phone,
            String state,
            int pageNo,
            int pageSize
    ){
        //封装参数
        HashMap<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("fullname",fullname);
        pageInfo.put("company",company);
        pageInfo.put("mphone",mphone);
        pageInfo.put("source",source);
        pageInfo.put("owner",owner);
        pageInfo.put("phone",phone);
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

}
