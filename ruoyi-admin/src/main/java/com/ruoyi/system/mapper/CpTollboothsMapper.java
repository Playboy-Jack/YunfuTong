package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.CpTollbooths;

/**
 * 收费站管理Mapper接口
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public interface CpTollboothsMapper 
{
    /**
     * 查询收费站管理
     * 
     * @param tollboothId 收费站管理主键
     * @return 收费站管理
     */
    public CpTollbooths selectCpTollboothsByTollboothId(Long tollboothId);

    /**
     * 查询收费站管理列表
     * 
     * @param cpTollbooths 收费站管理
     * @return 收费站管理集合
     */
    public List<CpTollbooths> selectCpTollboothsList(CpTollbooths cpTollbooths);

    /**
     * 新增收费站管理
     * 
     * @param cpTollbooths 收费站管理
     * @return 结果
     */
    public int insertCpTollbooths(CpTollbooths cpTollbooths);

    /**
     * 修改收费站管理
     * 
     * @param cpTollbooths 收费站管理
     * @return 结果
     */
    public int updateCpTollbooths(CpTollbooths cpTollbooths);

    /**
     * 删除收费站管理
     * 
     * @param tollboothId 收费站管理主键
     * @return 结果
     */
    public int deleteCpTollboothsByTollboothId(Long tollboothId);

    /**
     * 批量删除收费站管理
     * 
     * @param tollboothIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCpTollboothsByTollboothIds(Long[] tollboothIds);
}
