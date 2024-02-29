package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.CpVehicles;

/**
 * 车辆信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-02-26
 */
public interface CpVehiclesMapper 
{
    /**
     * 查询车辆信息
     * 
     * @param VehicleID 车辆信息主键
     * @return 车辆信息
     */
    public CpVehicles selectCpVehiclesByVehicleID(Long VehicleID);

    /**
     * 查询车辆信息列表
     * 
     * @param cpVehicles 车辆信息
     * @return 车辆信息集合
     */
    public List<CpVehicles> selectCpVehiclesList(CpVehicles cpVehicles);

    /**
     * 新增车辆信息
     * 
     * @param cpVehicles 车辆信息
     * @return 结果
     */
    public int insertCpVehicles(CpVehicles cpVehicles);

    /**
     * 修改车辆信息
     * 
     * @param cpVehicles 车辆信息
     * @return 结果
     */
    public int updateCpVehicles(CpVehicles cpVehicles);

    /**
     * 删除车辆信息
     * 
     * @param VehicleID 车辆信息主键
     * @return 结果
     */
    public int deleteCpVehiclesByVehicleID(Long VehicleID);

    /**
     * 批量删除车辆信息
     * 
     * @param VehicleIDs 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCpVehiclesByVehicleIDs(Long[] VehicleIDs);
}