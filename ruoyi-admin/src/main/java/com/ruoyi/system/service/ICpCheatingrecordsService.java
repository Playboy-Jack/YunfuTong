package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.CpCheatingrecords;

/**
 * 作弊记录Service接口
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public interface ICpCheatingrecordsService 
{
    /**
     * 查询作弊记录
     * 
     * @param recordId 作弊记录主键
     * @return 作弊记录
     */
    public CpCheatingrecords selectCpCheatingrecordsByRecordId(Long recordId);

    /**
     * 查询作弊记录列表
     * 
     * @param cpCheatingrecords 作弊记录
     * @return 作弊记录集合
     */
    public List<CpCheatingrecords> selectCpCheatingrecordsList(CpCheatingrecords cpCheatingrecords);

    /**
     * 新增作弊记录
     * 
     * @param cpCheatingrecords 作弊记录
     * @return 结果
     */
    public int insertCpCheatingrecords(CpCheatingrecords cpCheatingrecords);

    /**
     * 修改作弊记录
     * 
     * @param cpCheatingrecords 作弊记录
     * @return 结果
     */
    public int updateCpCheatingrecords(CpCheatingrecords cpCheatingrecords);

    /**
     * 批量删除作弊记录
     * 
     * @param recordIds 需要删除的作弊记录主键集合
     * @return 结果
     */
    public int deleteCpCheatingrecordsByRecordIds(Long[] recordIds);

    /**
     * 删除作弊记录信息
     * 
     * @param recordId 作弊记录主键
     * @return 结果
     */
    public int deleteCpCheatingrecordsByRecordId(Long recordId);
}
