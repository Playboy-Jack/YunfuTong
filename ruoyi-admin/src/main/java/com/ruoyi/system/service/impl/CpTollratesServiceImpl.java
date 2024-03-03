package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CpTollratesMapper;
import com.ruoyi.system.domain.CpTollrates;
import com.ruoyi.system.service.ICpTollratesService;

/**
 * 收费标准Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@Service
public class CpTollratesServiceImpl implements ICpTollratesService 
{
    @Autowired
    private CpTollratesMapper cpTollratesMapper;

    /**
     * 查询收费标准
     * 
     * @param rateId 收费标准主键
     * @return 收费标准
     */
    @Override
    public CpTollrates selectCpTollratesByRateId(Long rateId)
    {
        return cpTollratesMapper.selectCpTollratesByRateId(rateId);
    }

    /**
     * 查询收费标准列表
     * 
     * @param cpTollrates 收费标准
     * @return 收费标准
     */
    @Override
    public List<CpTollrates> selectCpTollratesList(CpTollrates cpTollrates)
    {
        return cpTollratesMapper.selectCpTollratesList(cpTollrates);
    }

    /**
     * 新增收费标准
     * 
     * @param cpTollrates 收费标准
     * @return 结果
     */
    @Override
    public int insertCpTollrates(CpTollrates cpTollrates)
    {
        return cpTollratesMapper.insertCpTollrates(cpTollrates);
    }

    /**
     * 修改收费标准
     * 
     * @param cpTollrates 收费标准
     * @return 结果
     */
    @Override
    public int updateCpTollrates(CpTollrates cpTollrates)
    {
        return cpTollratesMapper.updateCpTollrates(cpTollrates);
    }

    /**
     * 批量删除收费标准
     * 
     * @param rateIds 需要删除的收费标准主键
     * @return 结果
     */
    @Override
    public int deleteCpTollratesByRateIds(Long[] rateIds)
    {
        return cpTollratesMapper.deleteCpTollratesByRateIds(rateIds);
    }

    /**
     * 删除收费标准信息
     * 
     * @param rateId 收费标准主键
     * @return 结果
     */
    @Override
    public int deleteCpTollratesByRateId(Long rateId)
    {
        return cpTollratesMapper.deleteCpTollratesByRateId(rateId);
    }
}
