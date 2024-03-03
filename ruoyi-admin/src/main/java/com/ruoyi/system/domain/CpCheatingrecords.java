package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 作弊记录对象 cp_cheatingrecords
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public class CpCheatingrecords extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 作弊记录ID */
    private Long recordId;

    /** 通行记录ID */
    @Excel(name = "通行记录ID")
    private Long transactionId;

    /** 作弊类型 */
    @Excel(name = "作弊类型")
    private String cheatingType;

    /** 作弊检测时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "作弊检测时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date detectionTime;

    /** 处理状态 */
    @Excel(name = "处理状态")
    private String handlingStatus;

    /** 处理细节 */
    @Excel(name = "处理细节")
    private String handlingDetails;

    public void setRecordId(Long recordId) 
    {
        this.recordId = recordId;
    }

    public Long getRecordId() 
    {
        return recordId;
    }
    public void setTransactionId(Long transactionId) 
    {
        this.transactionId = transactionId;
    }

    public Long getTransactionId() 
    {
        return transactionId;
    }
    public void setCheatingType(String cheatingType) 
    {
        this.cheatingType = cheatingType;
    }

    public String getCheatingType() 
    {
        return cheatingType;
    }
    public void setDetectionTime(Date detectionTime) 
    {
        this.detectionTime = detectionTime;
    }

    public Date getDetectionTime() 
    {
        return detectionTime;
    }
    public void setHandlingStatus(String handlingStatus) 
    {
        this.handlingStatus = handlingStatus;
    }

    public String getHandlingStatus() 
    {
        return handlingStatus;
    }
    public void setHandlingDetails(String handlingDetails) 
    {
        this.handlingDetails = handlingDetails;
    }

    public String getHandlingDetails() 
    {
        return handlingDetails;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("recordId", getRecordId())
            .append("transactionId", getTransactionId())
            .append("cheatingType", getCheatingType())
            .append("detectionTime", getDetectionTime())
            .append("handlingStatus", getHandlingStatus())
            .append("handlingDetails", getHandlingDetails())
            .toString();
    }
}
