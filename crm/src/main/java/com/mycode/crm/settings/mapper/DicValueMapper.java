package com.mycode.crm.settings.mapper;

import com.mycode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {

    /**
     * 查询数据字典 根据数据字典类型
     * @param typeCode
     * @return 数据字典
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);
    //查询单条信息 通过类型名
    DicValue selectDicValueByValue(String value);
}