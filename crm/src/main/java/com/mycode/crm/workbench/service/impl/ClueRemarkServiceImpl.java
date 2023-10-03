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
     * 保存单条线索备注
     * @param clueRemark
     * @return 保存了多少条线索备注
     */
    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    /**
     * 删除单条线索备注 根据id
     * @param id
     * @return 删除的线索备注条数
     */
    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

    /**
     * 修改单条线索 根据id
     * @param clueRemark
     * @return 修改了多少条线索备注
     */
    @Override
    public int modifyClueRemarkById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemarkById(clueRemark);
    }

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
