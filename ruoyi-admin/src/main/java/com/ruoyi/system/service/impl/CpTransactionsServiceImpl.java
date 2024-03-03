package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CpTransactionsMapper;
import com.ruoyi.system.domain.CpTransactions;
import com.ruoyi.system.service.ICpTransactionsService;

/**
 * 通行记录Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-03-03
 */
@Service
public class CpTransactionsServiceImpl implements ICpTransactionsService 
{
    @Autowired
    private CpTransactionsMapper cpTransactionsMapper;

    /**
     * 查询通行记录
     * 
     * @param transactionId 通行记录主键
     * @return 通行记录
     */
    @Override
    public CpTransactions selectCpTransactionsByTransactionId(Long transactionId)
    {
        return cpTransactionsMapper.selectCpTransactionsByTransactionId(transactionId);
    }

    /**
     * 查询通行记录列表
     * 
     * @param cpTransactions 通行记录
     * @return 通行记录
     */
    @Override
    public List<CpTransactions> selectCpTransactionsList(CpTransactions cpTransactions)
    {
        return cpTransactionsMapper.selectCpTransactionsList(cpTransactions);
    }

    /**
     * 新增通行记录
     * 
     * @param cpTransactions 通行记录
     * @return 结果
     */
    @Override
    public int insertCpTransactions(CpTransactions cpTransactions)
    {
        return cpTransactionsMapper.insertCpTransactions(cpTransactions);
    }

    /**
     * 修改通行记录
     * 
     * @param cpTransactions 通行记录
     * @return 结果
     */
    @Override
    public int updateCpTransactions(CpTransactions cpTransactions)
    {
        return cpTransactionsMapper.updateCpTransactions(cpTransactions);
    }

    /**
     * 批量删除通行记录
     * 
     * @param transactionIds 需要删除的通行记录主键
     * @return 结果
     */
    @Override
    public int deleteCpTransactionsByTransactionIds(Long[] transactionIds)
    {
        return cpTransactionsMapper.deleteCpTransactionsByTransactionIds(transactionIds);
    }

    /**
     * 删除通行记录信息
     * 
     * @param transactionId 通行记录主键
     * @return 结果
     */
    @Override
    public int deleteCpTransactionsByTransactionId(Long transactionId)
    {
        return cpTransactionsMapper.deleteCpTransactionsByTransactionId(transactionId);
    }
}
