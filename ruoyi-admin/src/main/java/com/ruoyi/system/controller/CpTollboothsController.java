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
import com.ruoyi.system.domain.CpTollbooths;
import com.ruoyi.system.service.ICpTollboothsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 收费站管理Controller
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@RestController
@RequestMapping("/system/tollbooths")
public class CpTollboothsController extends BaseController
{
    @Autowired
    private ICpTollboothsService cpTollboothsService;

    /**
     * 查询收费站管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:tollbooths:list')")
    @GetMapping("/list")
    public TableDataInfo list(CpTollbooths cpTollbooths)
    {
        startPage();
        List<CpTollbooths> list = cpTollboothsService.selectCpTollboothsList(cpTollbooths);
        return getDataTable(list);
    }

    /**
     * 导出收费站管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:tollbooths:export')")
    @Log(title = "收费站管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CpTollbooths cpTollbooths)
    {
        List<CpTollbooths> list = cpTollboothsService.selectCpTollboothsList(cpTollbooths);
        ExcelUtil<CpTollbooths> util = new ExcelUtil<CpTollbooths>(CpTollbooths.class);
        util.exportExcel(response, list, "收费站管理数据");
    }

    /**
     * 获取收费站管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:tollbooths:query')")
    @GetMapping(value = "/{tollboothId}")
    public AjaxResult getInfo(@PathVariable("tollboothId") Long tollboothId)
    {
        return success(cpTollboothsService.selectCpTollboothsByTollboothId(tollboothId));
    }

    /**
     * 新增收费站管理
     */
    @PreAuthorize("@ss.hasPermi('system:tollbooths:add')")
    @Log(title = "收费站管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CpTollbooths cpTollbooths)
    {
        return toAjax(cpTollboothsService.insertCpTollbooths(cpTollbooths));
    }

    /**
     * 修改收费站管理
     */
    @PreAuthorize("@ss.hasPermi('system:tollbooths:edit')")
    @Log(title = "收费站管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CpTollbooths cpTollbooths)
    {
        return toAjax(cpTollboothsService.updateCpTollbooths(cpTollbooths));
    }

    /**
     * 删除收费站管理
     */
    @PreAuthorize("@ss.hasPermi('system:tollbooths:remove')")
    @Log(title = "收费站管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{tollboothIds}")
    public AjaxResult remove(@PathVariable Long[] tollboothIds)
    {
        return toAjax(cpTollboothsService.deleteCpTollboothsByTollboothIds(tollboothIds));
    }
}
