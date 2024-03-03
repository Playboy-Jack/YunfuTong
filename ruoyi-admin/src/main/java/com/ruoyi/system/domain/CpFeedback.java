package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 反馈信息对象 cp_feedback
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public class CpFeedback extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 反馈信息ID */
    private Long feedbackId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 反馈内容 */
    @Excel(name = "反馈内容")
    private String feedbackText;

    /** 反馈时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "反馈时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date timestamp;

    public void setFeedbackId(Long feedbackId) 
    {
        this.feedbackId = feedbackId;
    }

    public Long getFeedbackId() 
    {
        return feedbackId;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setFeedbackText(String feedbackText) 
    {
        this.feedbackText = feedbackText;
    }

    public String getFeedbackText() 
    {
        return feedbackText;
    }
    public void setTimestamp(Date timestamp) 
    {
        this.timestamp = timestamp;
    }

    public Date getTimestamp() 
    {
        return timestamp;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("feedbackId", getFeedbackId())
            .append("userId", getUserId())
            .append("feedbackText", getFeedbackText())
            .append("timestamp", getTimestamp())
            .toString();
    }
}
