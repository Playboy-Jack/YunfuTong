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
import com.ruoyi.system.domain.CpTransactions;
import com.ruoyi.system.service.ICpTransactionsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 通行记录Controller
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@RestController
@RequestMapping("/system/transactions")
public class CpTransactionsController extends BaseController
{
    @Autowired
    private ICpTransactionsService cpTransactionsService;

    /**
     * 查询通行记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:transactions:list')")
    @GetMapping("/list")
    public TableDataInfo list(CpTransactions cpTransactions)
    {
        startPage();
        List<CpTransactions> list = cpTransactionsService.selectCpTransactionsList(cpTransactions);
        return getDataTable(list);
    }

    /**
     * 导出通行记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:transactions:export')")
    @Log(title = "通行记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CpTransactions cpTransactions)
    {
        List<CpTransactions> list = cpTransactionsService.selectCpTransactionsList(cpTransactions);
        ExcelUtil<CpTransactions> util = new ExcelUtil<CpTransactions>(CpTransactions.class);
        util.exportExcel(response, list, "通行记录数据");
    }

    /**
     * 获取通行记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:transactions:query')")
    @GetMapping(value = "/{transactionId}")
    public AjaxResult getInfo(@PathVariable("transactionId") Long transactionId)
    {
        return success(cpTransactionsService.selectCpTransactionsByTransactionId(transactionId));
    }

    /**
     * 新增通行记录
     */
    @PreAuthorize("@ss.hasPermi('system:transactions:add')")
    @Log(title = "通行记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CpTransactions cpTransactions)
    {
        return toAjax(cpTransactionsService.insertCpTransactions(cpTransactions));
    }

    /**
     * 修改通行记录
     */
    @PreAuthorize("@ss.hasPermi('system:transactions:edit')")
    @Log(title = "通行记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CpTransactions cpTransactions)
    {
        return toAjax(cpTransactionsService.updateCpTransactions(cpTransactions));
    }

    /**
     * 删除通行记录
     */
    @PreAuthorize("@ss.hasPermi('system:transactions:remove')")
    @Log(title = "通行记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{transactionIds}")
    public AjaxResult remove(@PathVariable Long[] transactionIds)
    {
        return toAjax(cpTransactionsService.deleteCpTransactionsByTransactionIds(transactionIds));
    }
}
