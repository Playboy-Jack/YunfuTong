package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 车辆信息对象 cp_vehicles
 * 
 * @author ruoyi
 * @date 2024-02-26
 */
public class CpVehicles extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 车辆ID */
    private Long VehicleID;

    /** 用户ID，外键关联到用户表的UserID */
    @Excel(name = "用户ID，外键关联到用户表的UserID")
    private Long UserID;

    /** 车牌号，唯一 */
    @Excel(name = "车牌号，唯一")
    private String LicensePlate;

    /** 车辆类型 */
    @Excel(name = "车辆类型")
    private String VehicleType;

    /** 车辆品牌 */
    @Excel(name = "车辆品牌")
    private String VehicleBrand;

    /** 车辆型号 */
    @Excel(name = "车辆型号")
    private String VehicleModel;

    public void setVehicleID(Long VehicleID) 
    {
        this.VehicleID = VehicleID;
    }

    public Long getVehicleID() 
    {
        return VehicleID;
    }
    public void setUserID(Long UserID) 
    {
        this.UserID = UserID;
    }

    public Long getUserID() 
    {
        return UserID;
    }
    public void setLicensePlate(String LicensePlate) 
    {
        this.LicensePlate = LicensePlate;
    }

    public String getLicensePlate() 
    {
        return LicensePlate;
    }
    public void setVehicleType(String VehicleType) 
    {
        this.VehicleType = VehicleType;
    }

    public String getVehicleType() 
    {
        return VehicleType;
    }
    public void setVehicleBrand(String VehicleBrand) 
    {
        this.VehicleBrand = VehicleBrand;
    }

    public String getVehicleBrand() 
    {
        return VehicleBrand;
    }
    public void setVehicleModel(String VehicleModel) 
    {
        this.VehicleModel = VehicleModel;
    }

    public String getVehicleModel() 
    {
        return VehicleModel;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("VehicleID", getVehicleID())
            .append("UserID", getUserID())
            .append("LicensePlate", getLicensePlate())
            .append("VehicleType", getVehicleType())
            .append("VehicleBrand", getVehicleBrand())
            .append("VehicleModel", getVehicleModel())
            .toString();
    }
}
