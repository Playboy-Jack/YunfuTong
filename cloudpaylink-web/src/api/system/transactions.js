import request from '@/utils/request'

// 查询通行记录列表
export function listTransactions(query) {
  return request({
    url: '/system/transactions/list',
    method: 'get',
    params: query
  })
}

// 查询通行记录详细
export function getTransactions(transactionId) {
  return request({
    url: '/system/transactions/' + transactionId,
    method: 'get'
  })
}

// 新增通行记录
export function addTransactions(data) {
  return request({
    url: '/system/transactions',
    method: 'post',
    data: data
  })
}

// 修改通行记录
export function updateTransactions(data) {
  return request({
    url: '/system/transactions',
    method: 'put',
    data: data
  })
}

// 删除通行记录
export function delTransactions(transactionId) {
  return request({
    url: '/system/transactions/' + transactionId,
    method: 'delete'
  })
}
