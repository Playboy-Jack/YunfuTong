import request from '@/utils/request'

// 查询收费标准列表
export function listTollrates(query) {
  return request({
    url: '/system/tollrates/list',
    method: 'get',
    params: query
  })
}

// 查询收费标准详细
export function getTollrates(rateId) {
  return request({
    url: '/system/tollrates/' + rateId,
    method: 'get'
  })
}

// 新增收费标准
export function addTollrates(data) {
  return request({
    url: '/system/tollrates',
    method: 'post',
    data: data
  })
}

// 修改收费标准
export function updateTollrates(data) {
  return request({
    url: '/system/tollrates',
    method: 'put',
    data: data
  })
}

// 删除收费标准
export function delTollrates(rateId) {
  return request({
    url: '/system/tollrates/' + rateId,
    method: 'delete'
  })
}
