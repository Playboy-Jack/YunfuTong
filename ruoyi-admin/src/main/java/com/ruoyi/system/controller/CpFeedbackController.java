package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.CpFeedback;
import com.ruoyi.system.service.ICpFeedbackService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 反馈信息Controller
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@RestController
@RequestMapping("/system/feedback")
public class CpFeedbackController extends BaseController
{
    @Autowired
    private ICpFeedbackService cpFeedbackService;

    /**
     * 查询反馈信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:list')")
    @GetMapping("/list")
    public TableDataInfo list(CpFeedback cpFeedback)
    {
        startPage();
        List<CpFeedback> list = cpFeedbackService.selectCpFeedbackList(cpFeedback);
        return getDataTable(list);
    }

    /**
     * 导出反馈信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:export')")
    @Log(title = "反馈信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CpFeedback cpFeedback)
    {
        List<CpFeedback> list = cpFeedbackService.selectCpFeedbackList(cpFeedback);
        ExcelUtil<CpFeedback> util = new ExcelUtil<CpFeedback>(CpFeedback.class);
        util.exportExcel(response, list, "反馈信息数据");
    }

    /**
     * 获取反馈信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:query')")
    @GetMapping(value = "/{feedbackId}")
    public AjaxResult getInfo(@PathVariable("feedbackId") Long feedbackId)
    {
        return success(cpFeedbackService.selectCpFeedbackByFeedbackId(feedbackId));
    }

    /**
     * 新增反馈信息
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:add')")
    @Log(title = "反馈信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CpFeedback cpFeedback)
    {
        return toAjax(cpFeedbackService.insertCpFeedback(cpFeedback));
    }

    /**
     * 修改反馈信息
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:edit')")
    @Log(title = "反馈信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CpFeedback cpFeedback)
    {
        return toAjax(cpFeedbackService.updateCpFeedback(cpFeedback));
    }

    /**
     * 删除反馈信息
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:remove')")
    @Log(title = "反馈信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{feedbackIds}")
    public AjaxResult remove(@PathVariable Long[] feedbackIds)
    {
        return toAjax(cpFeedbackService.deleteCpFeedbackByFeedbackIds(feedbackIds));
    }
}
