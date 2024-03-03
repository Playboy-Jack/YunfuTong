package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 收费标准对象 cp_tollrates
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public class CpTollrates extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 费率ID */
    private Long rateId;

    /** 车辆类型 */
    @Excel(name = "车辆类型")
    private String vehicleType;

    /** 收费站ID */
    @Excel(name = "收费站ID")
    private Long tollboothId;

    /** 车次基础费用 */
    @Excel(name = "车次基础费用")
    private BigDecimal baseFee;

    /** 每公里费用 */
    @Excel(name = "每公里费用")
    private BigDecimal perKilometerFee;

    /** 费率生效日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "费率生效日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date validFrom;

    /** 费率截止日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "费率截止日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date validTo;

    public void setRateId(Long rateId) 
    {
        this.rateId = rateId;
    }

    public Long getRateId() 
    {
        return rateId;
    }
    public void setVehicleType(String vehicleType) 
    {
        this.vehicleType = vehicleType;
    }

    public String getVehicleType() 
    {
        return vehicleType;
    }
    public void setTollboothId(Long tollboothId) 
    {
        this.tollboothId = tollboothId;
    }

    public Long getTollboothId() 
    {
        return tollboothId;
    }
    public void setBaseFee(BigDecimal baseFee) 
    {
        this.baseFee = baseFee;
    }

    public BigDecimal getBaseFee() 
    {
        return baseFee;
    }
    public void setPerKilometerFee(BigDecimal perKilometerFee) 
    {
        this.perKilometerFee = perKilometerFee;
    }

    public BigDecimal getPerKilometerFee() 
    {
        return perKilometerFee;
    }
    public void setValidFrom(Date validFrom) 
    {
        this.validFrom = validFrom;
    }

    public Date getValidFrom() 
    {
        return validFrom;
    }
    public void setValidTo(Date validTo) 
    {
        this.validTo = validTo;
    }

    public Date getValidTo() 
    {
        return validTo;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("rateId", getRateId())
            .append("vehicleType", getVehicleType())
            .append("tollboothId", getTollboothId())
            .append("baseFee", getBaseFee())
            .append("perKilometerFee", getPerKilometerFee())
            .append("validFrom", getValidFrom())
            .append("validTo", getValidTo())
            .toString();
    }
}
