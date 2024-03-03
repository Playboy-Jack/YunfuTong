package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 车辆信息对象 cp_vehicles
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public class CpVehicles extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 车辆ID */
    private Long vehicleId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 车牌号 */
    @Excel(name = "车牌号")
    private String licensePlate;

    /** 车辆类型 */
    @Excel(name = "车辆类型")
    private String vehicleType;

    /** 车辆品牌 */
    @Excel(name = "车辆品牌")
    private String vehicleBrand;

    /** 车辆型号 */
    @Excel(name = "车辆型号")
    private String vehicleModel;

    public void setVehicleId(Long vehicleId) 
    {
        this.vehicleId = vehicleId;
    }

    public Long getVehicleId() 
    {
        return vehicleId;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setLicensePlate(String licensePlate) 
    {
        this.licensePlate = licensePlate;
    }

    public String getLicensePlate() 
    {
        return licensePlate;
    }
    public void setVehicleType(String vehicleType) 
    {
        this.vehicleType = vehicleType;
    }

    public String getVehicleType() 
    {
        return vehicleType;
    }
    public void setVehicleBrand(String vehicleBrand) 
    {
        this.vehicleBrand = vehicleBrand;
    }

    public String getVehicleBrand() 
    {
        return vehicleBrand;
    }
    public void setVehicleModel(String vehicleModel) 
    {
        this.vehicleModel = vehicleModel;
    }

    public String getVehicleModel() 
    {
        return vehicleModel;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("vehicleId", getVehicleId())
            .append("userId", getUserId())
            .append("licensePlate", getLicensePlate())
            .append("vehicleType", getVehicleType())
            .append("vehicleBrand", getVehicleBrand())
            .append("vehicleModel", getVehicleModel())
            .toString();
    }
}
