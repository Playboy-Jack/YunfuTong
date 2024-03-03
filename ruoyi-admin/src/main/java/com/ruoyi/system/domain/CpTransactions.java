package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 通行记录对象 cp_transactions
 * 
 * @author ruoyi.
 * @date 2024-03-03
 */
public class CpTransactions extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 通行记录ID */
    private Long transactionId;

    /** 车辆ID */
    @Excel(name = "车辆ID")
    private Long vehicleId;

    /** 车辆进入时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "车辆进入时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date entryTime;

    /** 车辆离开时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "车辆离开时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date exitTime;

    /** 通行距离 */
    @Excel(name = "通行距离")
    private Long distance;

    /** 通行费用 */
    @Excel(name = "通行费用")
    private BigDecimal tollAmount;

    /** 支付状态 */
    @Excel(name = "支付状态")
    private String paymentStatus;

    /** 收费站ID */
    @Excel(name = "收费站ID")
    private Long tollBoothId;

    public void setTransactionId(Long transactionId) 
    {
        this.transactionId = transactionId;
    }

    public Long getTransactionId() 
    {
        return transactionId;
    }
    public void setVehicleId(Long vehicleId) 
    {
        this.vehicleId = vehicleId;
    }

    public Long getVehicleId() 
    {
        return vehicleId;
    }
    public void setEntryTime(Date entryTime) 
    {
        this.entryTime = entryTime;
    }

    public Date getEntryTime() 
    {
        return entryTime;
    }
    public void setExitTime(Date exitTime) 
    {
        this.exitTime = exitTime;
    }

    public Date getExitTime() 
    {
        return exitTime;
    }
    public void setDistance(Long distance) 
    {
        this.distance = distance;
    }

    public Long getDistance() 
    {
        return distance;
    }
    public void setTollAmount(BigDecimal tollAmount) 
    {
        this.tollAmount = tollAmount;
    }

    public BigDecimal getTollAmount() 
    {
        return tollAmount;
    }
    public void setPaymentStatus(String paymentStatus) 
    {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentStatus() 
    {
        return paymentStatus;
    }
    public void setTollBoothId(Long tollBoothId) 
    {
        this.tollBoothId = tollBoothId;
    }

    public Long getTollBoothId() 
    {
        return tollBoothId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("transactionId", getTransactionId())
            .append("vehicleId", getVehicleId())
            .append("entryTime", getEntryTime())
            .append("exitTime", getExitTime())
            .append("distance", getDistance())
            .append("tollAmount", getTollAmount())
            .append("paymentStatus", getPaymentStatus())
            .append("tollBoothId", getTollBoothId())
            .toString();
    }
}
