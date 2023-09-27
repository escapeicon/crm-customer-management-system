package com.mycode.crm.settings.service;

import com.mycode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {

    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
