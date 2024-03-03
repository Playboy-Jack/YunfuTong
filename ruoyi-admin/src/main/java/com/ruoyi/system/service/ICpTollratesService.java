package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.CpTollrates;

/**
 * 收费标准Service接口
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public interface ICpTollratesService 
{
    /**
     * 查询收费标准
     * 
     * @param rateId 收费标准主键
     * @return 收费标准
     */
    public CpTollrates selectCpTollratesByRateId(Long rateId);

    /**
     * 查询收费标准列表
     * 
     * @param cpTollrates 收费标准
     * @return 收费标准集合
     */
    public List<CpTollrates> selectCpTollratesList(CpTollrates cpTollrates);

    /**
     * 新增收费标准
     * 
     * @param cpTollrates 收费标准
     * @return 结果
     */
    public int insertCpTollrates(CpTollrates cpTollrates);

    /**
     * 修改收费标准
     * 
     * @param cpTollrates 收费标准
     * @return 结果
     */
    public int updateCpTollrates(CpTollrates cpTollrates);

    /**
     * 批量删除收费标准
     * 
     * @param rateIds 需要删除的收费标准主键集合
     * @return 结果
     */
    public int deleteCpTollratesByRateIds(Long[] rateIds);

    /**
     * 删除收费标准信息
     * 
     * @param rateId 收费标准主键
     * @return 结果
     */
    public int deleteCpTollratesByRateId(Long rateId);
}
