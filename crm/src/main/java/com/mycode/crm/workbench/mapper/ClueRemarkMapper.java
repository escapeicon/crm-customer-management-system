package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    int insert(ClueRemark record);
    int insertSelective(ClueRemark record);

    int deleteByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark record);
    int updateByPrimaryKey(ClueRemark record);

    ClueRemark selectByPrimaryKey(String id);

    /**
     * 查询单条线索备注 根据线索id
     * @param clueId
     * @return 线索实体类
     */
    List<ClueRemark> selectClueRemarkByClueId(String clueId);
}