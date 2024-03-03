package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CpVehiclesMapper;
import com.ruoyi.system.domain.CpVehicles;
import com.ruoyi.system.service.ICpVehiclesService;

/**
 * 车辆信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@Service
public class CpVehiclesServiceImpl implements ICpVehiclesService 
{
    @Autowired
    private CpVehiclesMapper cpVehiclesMapper;

    /**
     * 查询车辆信息
     * 
     * @param vehicleId 车辆信息主键
     * @return 车辆信息
     */
    @Override
    public CpVehicles selectCpVehiclesByVehicleId(Long vehicleId)
    {
        return cpVehiclesMapper.selectCpVehiclesByVehicleId(vehicleId);
    }

    /**
     * 查询车辆信息列表
     * 
     * @param cpVehicles 车辆信息
     * @return 车辆信息
     */
    @Override
    public List<CpVehicles> selectCpVehiclesList(CpVehicles cpVehicles)
    {
        return cpVehiclesMapper.selectCpVehiclesList(cpVehicles);
    }

    /**
     * 新增车辆信息
     * 
     * @param cpVehicles 车辆信息
     * @return 结果
     */
    @Override
    public int insertCpVehicles(CpVehicles cpVehicles)
    {
        return cpVehiclesMapper.insertCpVehicles(cpVehicles);
    }

    /**
     * 修改车辆信息
     * 
     * @param cpVehicles 车辆信息
     * @return 结果
     */
    @Override
    public int updateCpVehicles(CpVehicles cpVehicles)
    {
        return cpVehiclesMapper.updateCpVehicles(cpVehicles);
    }

    /**
     * 批量删除车辆信息
     * 
     * @param vehicleIds 需要删除的车辆信息主键
     * @return 结果
     */
    @Override
    public int deleteCpVehiclesByVehicleIds(Long[] vehicleIds)
    {
        return cpVehiclesMapper.deleteCpVehiclesByVehicleIds(vehicleIds);
    }

    /**
     * 删除车辆信息信息
     * 
     * @param vehicleId 车辆信息主键
     * @return 结果
     */
    @Override
    public int deleteCpVehiclesByVehicleId(Long vehicleId)
    {
        return cpVehiclesMapper.deleteCpVehiclesByVehicleId(vehicleId);
    }
}
