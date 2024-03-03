import request from '@/utils/request'

// 查询作弊记录列表
export function listCheatingrecords(query) {
  return request({
    url: '/system/cheatingrecords/list',
    method: 'get',
    params: query
  })
}

// 查询作弊记录详细
export function getCheatingrecords(recordId) {
  return request({
    url: '/system/cheatingrecords/' + recordId,
    method: 'get'
  })
}

// 新增作弊记录
export function addCheatingrecords(data) {
  return request({
    url: '/system/cheatingrecords',
    method: 'post',
    data: data
  })
}

// 修改作弊记录
export function updateCheatingrecords(data) {
  return request({
    url: '/system/cheatingrecords',
    method: 'put',
    data: data
  })
}

// 删除作弊记录
export function delCheatingrecords(recordId) {
  return request({
    url: '/system/cheatingrecords/' + recordId,
    method: 'delete'
  })
}
