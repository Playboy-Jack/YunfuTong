package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.CpTransactions;

/**
 * 通行记录Mapper接口
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
public interface CpTransactionsMapper 
{
    /**
     * 查询通行记录
     * 
     * @param transactionId 通行记录主键
     * @return 通行记录
     */
    public CpTransactions selectCpTransactionsByTransactionId(Long transactionId);

    /**
     * 查询通行记录列表
     * 
     * @param cpTransactions 通行记录
     * @return 通行记录集合
     */
    public List<CpTransactions> selectCpTransactionsList(CpTransactions cpTransactions);

    /**
     * 新增通行记录
     * 
     * @param cpTransactions 通行记录
     * @return 结果
     */
    public int insertCpTransactions(CpTransactions cpTransactions);

    /**
     * 修改通行记录
     * 
     * @param cpTransactions 通行记录
     * @return 结果
     */
    public int updateCpTransactions(CpTransactions cpTransactions);

    /**
     * 删除通行记录
     * 
     * @param transactionId 通行记录主键
     * @return 结果
     */
    public int deleteCpTransactionsByTransactionId(Long transactionId);

    /**
     * 批量删除通行记录
     * 
     * @param transactionIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCpTransactionsByTransactionIds(Long[] transactionIds);
}
