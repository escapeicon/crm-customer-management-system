package com.mycode.crm.settings.mapper;

import com.mycode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {


    int insert(DicValue record);
    int insertSelective(DicValue record);

    int deleteByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue record);
    int updateByPrimaryKey(DicValue record);

    DicValue selectByPrimaryKey(String id);

    /**
     * 查询数据字典 根据数据字典类型
     * @param typeCode
     * @return 数据字典
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);
}