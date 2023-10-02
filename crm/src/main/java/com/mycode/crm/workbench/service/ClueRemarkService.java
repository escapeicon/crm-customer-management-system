package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkById(String ClueId);
}
