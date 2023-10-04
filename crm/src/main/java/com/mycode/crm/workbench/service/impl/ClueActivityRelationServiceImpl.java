package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.ClueActivityRelation;
import com.mycode.crm.workbench.mapper.ClueActivityRelationMapper;
import com.mycode.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    /**
     * 保存线索市场活动关系 通过list集合
     * @param clueActivityRelationList
     * @return 保存条数
     */
    @Override
    public int saveClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(clueActivityRelationList);
    }
}
