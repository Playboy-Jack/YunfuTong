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
import com.ruoyi.system.domain.CpVehicles;
import com.ruoyi.system.service.ICpVehiclesService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 车辆信息Controller
 * 
 * @author ruoyi
 * @date 2024-02-26
 */
@RestController
@RequestMapping("/system/vehicles")
public class CpVehiclesController extends BaseController
{
    @Autowired
    private ICpVehiclesService cpVehiclesService;

    /**
     * 查询车辆信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:vehicles:list')")
    @GetMapping("/list")
    public TableDataInfo list(CpVehicles cpVehicles)
    {
        startPage();
        List<CpVehicles> list = cpVehiclesService.selectCpVehiclesList(cpVehicles);
        return getDataTable(list);
    }

    /**
     * 导出车辆信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:vehicles:export')")
    @Log(title = "车辆信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CpVehicles cpVehicles)
    {
        List<CpVehicles> list = cpVehiclesService.selectCpVehiclesList(cpVehicles);
        ExcelUtil<CpVehicles> util = new ExcelUtil<CpVehicles>(CpVehicles.class);
        util.exportExcel(response, list, "车辆信息数据");
    }

    /**
     * 获取车辆信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:vehicles:query')")
    @GetMapping(value = "/{VehicleID}")
    public AjaxResult getInfo(@PathVariable("VehicleID") Long VehicleID)
    {
        return success(cpVehiclesService.selectCpVehiclesByVehicleID(VehicleID));
    }

    /**
     * 新增车辆信息
     */
    @PreAuthorize("@ss.hasPermi('system:vehicles:add')")
    @Log(title = "车辆信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CpVehicles cpVehicles)
    {
        return toAjax(cpVehiclesService.insertCpVehicles(cpVehicles));
    }

    /**
     * 修改车辆信息
     */
    @PreAuthorize("@ss.hasPermi('system:vehicles:edit')")
    @Log(title = "车辆信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CpVehicles cpVehicles)
    {
        return toAjax(cpVehiclesService.updateCpVehicles(cpVehicles));
    }

    /**
     * 删除车辆信息
     */
    @PreAuthorize("@ss.hasPermi('system:vehicles:remove')")
    @Log(title = "车辆信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{VehicleIDs}")
    public AjaxResult remove(@PathVariable Long[] VehicleIDs)
    {
        return toAjax(cpVehiclesService.deleteCpVehiclesByVehicleIDs(VehicleIDs));
    }
}
