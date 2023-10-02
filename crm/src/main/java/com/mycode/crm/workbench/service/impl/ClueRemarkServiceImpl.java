package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.ClueRemark;
import com.mycode.crm.workbench.mapper.ClueMapper;
import com.mycode.crm.workbench.mapper.ClueRemarkMapper;
import com.mycode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    /**
     * 查询该线索id下所有线索备注
     * @param clueId
     * @return 线索备注集合
     */
    @Override
    public List<ClueRemark> queryClueRemarkById(String clueId) {
        return clueRemarkMapper.selectClueRemarkByClueId(clueId);
    }
}
