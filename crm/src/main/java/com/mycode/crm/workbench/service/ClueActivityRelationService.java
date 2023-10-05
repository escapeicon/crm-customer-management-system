package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int saveClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList);

    int deleteClueActivityRelationByObject(ClueActivityRelation clueActivityRelation);
}
