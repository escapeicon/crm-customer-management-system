package com.mycode.crm.settings.service.impl;

import com.mycode.crm.settings.domain.DicValue;
import com.mycode.crm.settings.mapper.DicValueMapper;
import com.mycode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    /**
     * 查询数据字典 根据类型
     * @param typeCode
     * @return 数据字典结果
     */
    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
