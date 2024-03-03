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
import com.ruoyi.system.domain.CpTollrates;
import com.ruoyi.system.service.ICpTollratesService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 收费标准Controller
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@RestController
@RequestMapping("/system/tollrates")
public class CpTollratesController extends BaseController
{
    @Autowired
    private ICpTollratesService cpTollratesService;

    /**
     * 查询收费标准列表
     */
    @PreAuthorize("@ss.hasPermi('system:tollrates:list')")
    @GetMapping("/list")
    public TableDataInfo list(CpTollrates cpTollrates)
    {
        startPage();
        List<CpTollrates> list = cpTollratesService.selectCpTollratesList(cpTollrates);
        return getDataTable(list);
    }

    /**
     * 导出收费标准列表
     */
    @PreAuthorize("@ss.hasPermi('system:tollrates:export')")
    @Log(title = "收费标准", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CpTollrates cpTollrates)
    {
        List<CpTollrates> list = cpTollratesService.selectCpTollratesList(cpTollrates);
        ExcelUtil<CpTollrates> util = new ExcelUtil<CpTollrates>(CpTollrates.class);
        util.exportExcel(response, list, "收费标准数据");
    }

    /**
     * 获取收费标准详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:tollrates:query')")
    @GetMapping(value = "/{rateId}")
    public AjaxResult getInfo(@PathVariable("rateId") Long rateId)
    {
        return success(cpTollratesService.selectCpTollratesByRateId(rateId));
    }

    /**
     * 新增收费标准
     */
    @PreAuthorize("@ss.hasPermi('system:tollrates:add')")
    @Log(title = "收费标准", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CpTollrates cpTollrates)
    {
        return toAjax(cpTollratesService.insertCpTollrates(cpTollrates));
    }

    /**
     * 修改收费标准
     */
    @PreAuthorize("@ss.hasPermi('system:tollrates:edit')")
    @Log(title = "收费标准", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CpTollrates cpTollrates)
    {
        return toAjax(cpTollratesService.updateCpTollrates(cpTollrates));
    }

    /**
     * 删除收费标准
     */
    @PreAuthorize("@ss.hasPermi('system:tollrates:remove')")
    @Log(title = "收费标准", businessType = BusinessType.DELETE)
	@DeleteMapping("/{rateIds}")
    public AjaxResult remove(@PathVariable Long[] rateIds)
    {
        return toAjax(cpTollratesService.deleteCpTollratesByRateIds(rateIds));
    }
}
