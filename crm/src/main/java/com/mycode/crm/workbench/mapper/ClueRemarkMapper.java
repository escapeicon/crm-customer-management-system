package com.mycode.crm.workbench.mapper;

import com.mycode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    int insert(ClueRemark record);
    int insertSelective(ClueRemark record);
    /**
     * 保存单条线索
     * @param clueRemark
     * @return 数据库更新条数
     */
    int insertClueRemark(ClueRemark clueRemark);

    /**
     * 删除单条线索 根据id
     * @param id
     * @return 数据库更新条数
     */
    int deleteClueRemarkById(String id);
    //删除单条线索 根据线索id
    int deleteClueRemarkByClueId(String clueId);

    int updateByPrimaryKeySelective(ClueRemark record);
    /**
     * 修改线索备注 根据id
     * @param clueRemark
     * @return 修改记录条数
     */
    int updateClueRemarkById(ClueRemark clueRemark);

    ClueRemark selectByPrimaryKey(String id);

    /**
     * 查询单条线索备注 根据线索id
     * @param clueId
     * @return 线索实体类
     */
    List<ClueRemark> selectClueRemarkByClueId(String clueId);
}