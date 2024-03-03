package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 收费站管理对象 cp_tollbooths
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public class CpTollbooths extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 收费站ID */
    private Long tollboothId;

    /** 收费站名 */
    @Excel(name = "收费站名")
    private String tollboothName;

    /** 收费站位置 */
    @Excel(name = "收费站位置")
    private String location;

    /** 运营状态 */
    @Excel(name = "运营状态")
    private String operationalStatus;

    public void setTollboothId(Long tollboothId) 
    {
        this.tollboothId = tollboothId;
    }

    public Long getTollboothId() 
    {
        return tollboothId;
    }
    public void setTollboothName(String tollboothName) 
    {
        this.tollboothName = tollboothName;
    }

    public String getTollboothName() 
    {
        return tollboothName;
    }
    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }
    public void setOperationalStatus(String operationalStatus) 
    {
        this.operationalStatus = operationalStatus;
    }

    public String getOperationalStatus() 
    {
        return operationalStatus;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("tollboothId", getTollboothId())
            .append("tollboothName", getTollboothName())
            .append("location", getLocation())
            .append("operationalStatus", getOperationalStatus())
            .toString();
    }
}
