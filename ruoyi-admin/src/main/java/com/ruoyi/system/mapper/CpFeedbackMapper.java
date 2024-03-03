package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.CpFeedback;

/**
 * 反馈信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public interface CpFeedbackMapper 
{
    /**
     * 查询反馈信息
     * 
     * @param feedbackId 反馈信息主键
     * @return 反馈信息
     */
    public CpFeedback selectCpFeedbackByFeedbackId(Long feedbackId);

    /**
     * 查询反馈信息列表
     * 
     * @param cpFeedback 反馈信息
     * @return 反馈信息集合
     */
    public List<CpFeedback> selectCpFeedbackList(CpFeedback cpFeedback);

    /**
     * 新增反馈信息
     * 
     * @param cpFeedback 反馈信息
     * @return 结果
     */
    public int insertCpFeedback(CpFeedback cpFeedback);

    /**
     * 修改反馈信息
     * 
     * @param cpFeedback 反馈信息
     * @return 结果
     */
    public int updateCpFeedback(CpFeedback cpFeedback);

    /**
     * 删除反馈信息
     * 
     * @param feedbackId 反馈信息主键
     * @return 结果
     */
    public int deleteCpFeedbackByFeedbackId(Long feedbackId);

    /**
     * 批量删除反馈信息
     * 
     * @param feedbackIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCpFeedbackByFeedbackIds(Long[] feedbackIds);
}
