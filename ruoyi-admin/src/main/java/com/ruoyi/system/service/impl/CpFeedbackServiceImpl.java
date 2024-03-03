package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CpFeedbackMapper;
import com.ruoyi.system.domain.CpFeedback;
import com.ruoyi.system.service.ICpFeedbackService;

/**
 * 反馈信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@Service
public class CpFeedbackServiceImpl implements ICpFeedbackService 
{
    @Autowired
    private CpFeedbackMapper cpFeedbackMapper;

    /**
     * 查询反馈信息
     * 
     * @param feedbackId 反馈信息主键
     * @return 反馈信息
     */
    @Override
    public CpFeedback selectCpFeedbackByFeedbackId(Long feedbackId)
    {
        return cpFeedbackMapper.selectCpFeedbackByFeedbackId(feedbackId);
    }

    /**
     * 查询反馈信息列表
     * 
     * @param cpFeedback 反馈信息
     * @return 反馈信息
     */
    @Override
    public List<CpFeedback> selectCpFeedbackList(CpFeedback cpFeedback)
    {
        return cpFeedbackMapper.selectCpFeedbackList(cpFeedback);
    }

    /**
     * 新增反馈信息
     * 
     * @param cpFeedback 反馈信息
     * @return 结果
     */
    @Override
    public int insertCpFeedback(CpFeedback cpFeedback)
    {
        return cpFeedbackMapper.insertCpFeedback(cpFeedback);
    }

    /**
     * 修改反馈信息
     * 
     * @param cpFeedback 反馈信息
     * @return 结果
     */
    @Override
    public int updateCpFeedback(CpFeedback cpFeedback)
    {
        return cpFeedbackMapper.updateCpFeedback(cpFeedback);
    }

    /**
     * 批量删除反馈信息
     * 
     * @param feedbackIds 需要删除的反馈信息主键
     * @return 结果
     */
    @Override
    public int deleteCpFeedbackByFeedbackIds(Long[] feedbackIds)
    {
        return cpFeedbackMapper.deleteCpFeedbackByFeedbackIds(feedbackIds);
    }

    /**
     * 删除反馈信息信息
     * 
     * @param feedbackId 反馈信息主键
     * @return 结果
     */
    @Override
    public int deleteCpFeedbackByFeedbackId(Long feedbackId)
    {
        return cpFeedbackMapper.deleteCpFeedbackByFeedbackId(feedbackId);
    }
}
