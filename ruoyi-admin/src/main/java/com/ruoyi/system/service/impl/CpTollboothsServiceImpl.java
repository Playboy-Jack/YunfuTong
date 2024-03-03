package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CpTollboothsMapper;
import com.ruoyi.system.domain.CpTollbooths;
import com.ruoyi.system.service.ICpTollboothsService;

/**
 * 收费站管理Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@Service
public class CpTollboothsServiceImpl implements ICpTollboothsService 
{
    @Autowired
    private CpTollboothsMapper cpTollboothsMapper;

    /**
     * 查询收费站管理
     * 
     * @param tollboothId 收费站管理主键
     * @return 收费站管理
     */
    @Override
    public CpTollbooths selectCpTollboothsByTollboothId(Long tollboothId)
    {
        return cpTollboothsMapper.selectCpTollboothsByTollboothId(tollboothId);
    }

    /**
     * 查询收费站管理列表
     * 
     * @param cpTollbooths 收费站管理
     * @return 收费站管理
     */
    @Override
    public List<CpTollbooths> selectCpTollboothsList(CpTollbooths cpTollbooths)
    {
        return cpTollboothsMapper.selectCpTollboothsList(cpTollbooths);
    }

    /**
     * 新增收费站管理
     * 
     * @param cpTollbooths 收费站管理
     * @return 结果
     */
    @Override
    public int insertCpTollbooths(CpTollbooths cpTollbooths)
    {
        return cpTollboothsMapper.insertCpTollbooths(cpTollbooths);
    }

    /**
     * 修改收费站管理
     * 
     * @param cpTollbooths 收费站管理
     * @return 结果
     */
    @Override
    public int updateCpTollbooths(CpTollbooths cpTollbooths)
    {
        return cpTollboothsMapper.updateCpTollbooths(cpTollbooths);
    }

    /**
     * 批量删除收费站管理
     * 
     * @param tollboothIds 需要删除的收费站管理主键
     * @return 结果
     */
    @Override
    public int deleteCpTollboothsByTollboothIds(Long[] tollboothIds)
    {
        return cpTollboothsMapper.deleteCpTollboothsByTollboothIds(tollboothIds);
    }

    /**
     * 删除收费站管理信息
     * 
     * @param tollboothId 收费站管理主键
     * @return 结果
     */
    @Override
    public int deleteCpTollboothsByTollboothId(Long tollboothId)
    {
        return cpTollboothsMapper.deleteCpTollboothsByTollboothId(tollboothId);
    }
}
