package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CpCheatingrecordsMapper;
import com.ruoyi.system.domain.CpCheatingrecords;
import com.ruoyi.system.service.ICpCheatingrecordsService;

/**
 * 作弊记录Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@Service
public class CpCheatingrecordsServiceImpl implements ICpCheatingrecordsService 
{
    @Autowired
    private CpCheatingrecordsMapper cpCheatingrecordsMapper;

    /**
     * 查询作弊记录
     * 
     * @param recordId 作弊记录主键
     * @return 作弊记录
     */
    @Override
    public CpCheatingrecords selectCpCheatingrecordsByRecordId(Long recordId)
    {
        return cpCheatingrecordsMapper.selectCpCheatingrecordsByRecordId(recordId);
    }

    /**
     * 查询作弊记录列表
     * 
     * @param cpCheatingrecords 作弊记录
     * @return 作弊记录
     */
    @Override
    public List<CpCheatingrecords> selectCpCheatingrecordsList(CpCheatingrecords cpCheatingrecords)
    {
        return cpCheatingrecordsMapper.selectCpCheatingrecordsList(cpCheatingrecords);
    }

    /**
     * 新增作弊记录
     * 
     * @param cpCheatingrecords 作弊记录
     * @return 结果
     */
    @Override
    public int insertCpCheatingrecords(CpCheatingrecords cpCheatingrecords)
    {
        return cpCheatingrecordsMapper.insertCpCheatingrecords(cpCheatingrecords);
    }

    /**
     * 修改作弊记录
     * 
     * @param cpCheatingrecords 作弊记录
     * @return 结果
     */
    @Override
    public int updateCpCheatingrecords(CpCheatingrecords cpCheatingrecords)
    {
        return cpCheatingrecordsMapper.updateCpCheatingrecords(cpCheatingrecords);
    }

    /**
     * 批量删除作弊记录
     * 
     * @param recordIds 需要删除的作弊记录主键
     * @return 结果
     */
    @Override
    public int deleteCpCheatingrecordsByRecordIds(Long[] recordIds)
    {
        return cpCheatingrecordsMapper.deleteCpCheatingrecordsByRecordIds(recordIds);
    }

    /**
     * 删除作弊记录信息
     * 
     * @param recordId 作弊记录主键
     * @return 结果
     */
    @Override
    public int deleteCpCheatingrecordsByRecordId(Long recordId)
    {
        return cpCheatingrecordsMapper.deleteCpCheatingrecordsByRecordId(recordId);
    }
}
