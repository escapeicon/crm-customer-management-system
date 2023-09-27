package com.mycode.crm.workbench.service;

import com.mycode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveClue(Clue clue);

    List<Clue> queryCluesByConditionForPage(Map<String,Object> pageInfo);
    int queryCountCluesByConditionForPage(Map<String,Object> pageInfo);
    List<Clue> queryAllClue();
}
