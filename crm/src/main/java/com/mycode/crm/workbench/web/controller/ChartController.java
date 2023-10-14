package com.mycode.crm.workbench.web.controller;

import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.service.DicValueService;
import com.mycode.crm.workbench.domain.Activity;
import com.mycode.crm.workbench.domain.ChartObj;
import com.mycode.crm.workbench.service.ActivitiesService;
import com.mycode.crm.workbench.service.ClueService;
import com.mycode.crm.workbench.service.ContactsService;
import com.mycode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
public class ChartController {

    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ActivitiesService activitiesService;

    /**
     * 跳转交易统计图表页面
     * @return
     */
    @RequestMapping("/workbench/chart/transaction/toTransactionChart.do")
    public String toTransactionChart(){
        return "workbench/chart/transaction/index";
    }

    /**
     * 获取交易统计图表数据
     * @return
     */
    @RequestMapping("/workbench/chart/transaction/getTransactionData.do")
    public @ResponseBody Object getTransactionData(){
        HashMap<String, Object> returnInfo = new HashMap<>();

        //获取交易阶段
        List<DicValue> stagesOrigin = dicValueService.queryDicValueByTypeCode("stage");
        //封装交易阶段值
        ArrayList<String> stages = new ArrayList<>();
        for(DicValue stage:stagesOrigin){
            stages.add(stage.getValue());
        }

        //获取所有交易和交易所处阶段
        List<ChartObj> chartObjs = transactionService.queryCountGroupByStage();

        returnInfo.put("stages",stages);
        returnInfo.put("chartObjs", chartObjs);

        return returnInfo;
    }

    /**
     * 跳转客户联系人
     * @return
     */
    @RequestMapping("/workbench/chart/customerAndContacts/toCustomerAndContactChart.do")
    public String toCustomerAndContactChart(){
        return "workbench/chart/customerAndContacts/index";
    }

    /**
     * 获取联系人 客户数据
     * @return
     */
    @RequestMapping("/workbench/chart/customerAndContacts/getContactsData.do")
    public @ResponseBody Object getContactsData(){
        List<ChartObj> chartObjs = contactsService.queryCountGroupByCustomer();
        return chartObjs;
    }

    /**
     * 跳转线索图标页面
     * @return
     */
    @RequestMapping("/workbench/chart/clue/toClueChart.do")
    public String toClueChart(){
        return "workbench/chart/clue/index";
    }

    /**
     * 获取线索 数据
     * @return
     */
    @RequestMapping("/workbench/chart/clue/getClueData.do")
    public @ResponseBody Object getClueData(){
        return clueService.queryCountGroupByState();
    }

    /**
     * 跳转至市场活动图标页面
     * @return
     */
    @RequestMapping("/workbench/chart/activity/toActivityChart.do")
    public String toActivityChart(){
        return "workbench/chart/activity/index";
    }

    /**
     * 获取市场活动数据
     * @return
     */
    @RequestMapping("/workbench/chart/activity/getActivityData.do")
    public @ResponseBody Object getActivityData(){
        return activitiesService.queryAllActivities();
    }
}
