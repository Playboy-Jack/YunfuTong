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
import com.ruoyi.system.domain.CpCheatingrecords;
import com.ruoyi.system.service.ICpCheatingrecordsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 作弊记录Controller
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@RestController
@RequestMapping("/system/cheatingrecords")
public class CpCheatingrecordsController extends BaseController
{
    @Autowired
    private ICpCheatingrecordsService cpCheatingrecordsService;

    /**
     * 查询作弊记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:cheatingrecords:list')")
    @GetMapping("/list")
    public TableDataInfo list(CpCheatingrecords cpCheatingrecords)
    {
        startPage();
        List<CpCheatingrecords> list = cpCheatingrecordsService.selectCpCheatingrecordsList(cpCheatingrecords);
        return getDataTable(list);
    }

    /**
     * 导出作弊记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:cheatingrecords:export')")
    @Log(title = "作弊记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CpCheatingrecords cpCheatingrecords)
    {
        List<CpCheatingrecords> list = cpCheatingrecordsService.selectCpCheatingrecordsList(cpCheatingrecords);
        ExcelUtil<CpCheatingrecords> util = new ExcelUtil<CpCheatingrecords>(CpCheatingrecords.class);
        util.exportExcel(response, list, "作弊记录数据");
    }

    /**
     * 获取作弊记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:cheatingrecords:query')")
    @GetMapping(value = "/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId)
    {
        return success(cpCheatingrecordsService.selectCpCheatingrecordsByRecordId(recordId));
    }

    /**
     * 新增作弊记录
     */
    @PreAuthorize("@ss.hasPermi('system:cheatingrecords:add')")
    @Log(title = "作弊记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CpCheatingrecords cpCheatingrecords)
    {
        return toAjax(cpCheatingrecordsService.insertCpCheatingrecords(cpCheatingrecords));
    }

    /**
     * 修改作弊记录
     */
    @PreAuthorize("@ss.hasPermi('system:cheatingrecords:edit')")
    @Log(title = "作弊记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CpCheatingrecords cpCheatingrecords)
    {
        return toAjax(cpCheatingrecordsService.updateCpCheatingrecords(cpCheatingrecords));
    }

    /**
     * 删除作弊记录
     */
    @PreAuthorize("@ss.hasPermi('system:cheatingrecords:remove')")
    @Log(title = "作弊记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{recordIds}")
    public AjaxResult remove(@PathVariable Long[] recordIds)
    {
        return toAjax(cpCheatingrecordsService.deleteCpCheatingrecordsByRecordIds(recordIds));
    }
}
