import request from '@/utils/request'

// 查询反馈信息列表
export function listFeedback(query) {
  return request({
    url: '/system/feedback/list',
    method: 'get',
    params: query
  })
}

// 查询反馈信息详细
export function getFeedback(feedbackId) {
  return request({
    url: '/system/feedback/' + feedbackId,
    method: 'get'
  })
}

// 新增反馈信息
export function addFeedback(data) {
  return request({
    url: '/system/feedback',
    method: 'post',
    data: data
  })
}

// 修改反馈信息
export function updateFeedback(data) {
  return request({
    url: '/system/feedback',
    method: 'put',
    data: data
  })
}

// 删除反馈信息
export function delFeedback(feedbackId) {
  return request({
    url: '/system/feedback/' + feedbackId,
    method: 'delete'
  })
}
