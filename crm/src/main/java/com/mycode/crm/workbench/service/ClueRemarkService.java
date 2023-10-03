package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    int saveClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);

    int modifyClueRemarkById(ClueRemark clueRemark);

    List<ClueRemark> queryClueRemarkById(String ClueId);
}
