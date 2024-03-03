import request from '@/utils/request'

// 查询收费站管理列表
export function listTollbooths(query) {
  return request({
    url: '/system/tollbooths/list',
    method: 'get',
    params: query
  })
}

// 查询收费站管理详细
export function getTollbooths(tollboothId) {
  return request({
    url: '/system/tollbooths/' + tollboothId,
    method: 'get'
  })
}

// 新增收费站管理
export function addTollbooths(data) {
  return request({
    url: '/system/tollbooths',
    method: 'post',
    data: data
  })
}

// 修改收费站管理
export function updateTollbooths(data) {
  return request({
    url: '/system/tollbooths',
    method: 'put',
    data: data
  })
}

// 删除收费站管理
export function delTollbooths(tollboothId) {
  return request({
    url: '/system/tollbooths/' + tollboothId,
    method: 'delete'
  })
}
