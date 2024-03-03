import request from '@/utils/request'

// 查询车辆信息列表
export function listVehicles(query) {
  return request({
    url: '/system/vehicles/list',
    method: 'get',
    params: query
  })
}

// 查询车辆信息详细
export function getVehicles(vehicleId) {
  return request({
    url: '/system/vehicles/' + vehicleId,
    method: 'get'
  })
}

// 新增车辆信息
export function addVehicles(data) {
  return request({
    url: '/system/vehicles',
    method: 'post',
    data: data
  })
}

// 修改车辆信息
export function updateVehicles(data) {
  return request({
    url: '/system/vehicles',
    method: 'put',
    data: data
  })
}

// 删除车辆信息
export function delVehicles(vehicleId) {
  return request({
    url: '/system/vehicles/' + vehicleId,
    method: 'delete'
  })
}
