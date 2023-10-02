package com.mycode.crm.workbench.service.impl;

import com.mycode.crm.workbench.domain.Clue;
import com.mycode.crm.workbench.mapper.ClueMapper;
import com.mycode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    /**
     * 创建线索
     * @param clue
     * @return 创建线索条数
     */
    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    /**
     * 删除线索 根据id数组
     * @param ids
     * @return 删除的条数
     */
    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    /**
     * 修改线索 根据id
     * @param clue
     * @return int
     */
    @Override
    public int updateClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    /**
     * 分页查询 条件查询
     * @param pageInfo
     * @return 查询线索结果
     */
    @Override
    public List<Clue> queryCluesByConditionForPage(Map<String, Object> pageInfo) {
        return clueMapper.selectClueByConditionForPage(pageInfo);
    }
    /**
     * 分页查询结果总数
     * @param pageInfo
     * @return 总数量
     */
    @Override
    public int queryCountCluesByConditionForPage(Map<String, Object> pageInfo) {
        return clueMapper.selectCountClueByConditionForPage(pageInfo);
    }
    /**
     * 查询所有线索
     * @return 线索集合
     */
    @Override
    public List<Clue> queryAllClue() {
        return clueMapper.selectAllClue();
    }
    /**
     * 查询单条线索 根据id
     * @param id
     * @return
     */
    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    /**
     * 查询单条线索 for detail 根据id
     * @param id
     * @return
     */
    @Override
    public Clue queryClueForRemarkById(String id) {
        return clueMapper.selectClueForRemarkById(id);
    }
}
