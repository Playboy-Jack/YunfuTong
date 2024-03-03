package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.CpTollrates;

/**
 * 收费标准Mapper接口
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public interface CpTollratesMapper 
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
     * 删除收费标准
     * 
     * @param rateId 收费标准主键
     * @return 结果
     */
    public int deleteCpTollratesByRateId(Long rateId);

    /**
     * 批量删除收费标准
     * 
     * @param rateIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCpTollratesByRateIds(Long[] rateIds);
}
