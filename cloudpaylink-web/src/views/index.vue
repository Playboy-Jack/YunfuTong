<template>
  <div class="app-container home">
    <el-row :gutter="20">
      <el-col :sm="24" :lg="24">
        <blockquote class="text-warning" style="font-size: 14px">
          <h1>云付通-高速公路收费管理系统</h1>
        </blockquote>

        <hr />
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :sm="24" :lg="12" style="padding-left: 20px">
        <h2>云付通-高速公路收费管理系统</h2>
        <p>
          高速公路收费管理系统是一个基于现代技术的全面管理平台，旨在有效管理和监控高速公路上的车辆通行情况，并确保收费和安全等方面的合规性。该系统采用了Vue和Element UI作为前端框架，Spring Boot和Spring Security作为后端框架，同时结合了Redis和JWT等技术，实现了多终端认证系统以及灵活的权限控制。
        </p>
      </el-col>

      <el-col :sm="24" :lg="12" style="padding-left: 50px">
        <el-row>
          <el-col :span="12">
            <h2>技术选型</h2>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="6">
            <h4>后端技术</h4>
            <ul>
              <li>SpringBoot</li>
              <li>Spring Security</li>
              <li>JWT</li>
              <li>MyBatis</li>
              <li>Druid</li>
              <li>Fastjson</li>
              <li>...</li>
            </ul>
          </el-col>
          <el-col :span="6">
            <h4>前端技术</h4>
            <ul>
              <li>Vue</li>
              <li>Vuex</li>
              <li>Element-ui</li>
              <li>Axios</li>
              <li>Sass</li>
              <li>Quill</li>
              <li>...</li>
            </ul>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-divider />
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="12" :lg="8">
        <el-card class="update-log">
          <div slot="header" class="clearfix">
            <span>联系信息</span>
          </div>
          <div class="body">

          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="8">
        <el-card class="update-log">
          <div slot="header" class="clearfix">
            <span>功能介绍</span>
          </div>
          <el-collapse accordion>
            <el-collapse-item title="用户管理模块">
              <ol>
                <li>注册账户：用户可以填写必要的个人信息注册新的账户，包括用户名、密码、邮箱地址和手机号码等。</li>
                <li>用户登录：注册过的用户可以使用用户名和密码登录系统，以便访问个人信息和其他功能。</li>
                <li>编辑个人信息：已登录的用户可以编辑自己的个人信息，如修改密码、更新邮箱地址和手机号码等。</li>
                <li>查看个人信息：已登录的用户可以查看自己的个人信息，包括用户名、邮箱地址和手机号码等。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="车辆管理模块">
              <ol>
                <li>添加车辆：用户和工作人员可以添加自己的车辆信息，包括车牌号、车型、品牌和型号等。</li>
                <li>编辑车辆信息：用户和工作人员可以编辑自己的车辆信息，包括修改车牌号、更新车型和品牌等。</li>
                <li>删除车辆：用户和工作人员可以删除自己的车辆信息，从系统中移除不再使用的车辆。</li>
                <li>查询车辆信息：用户可以查询自己拥有的车辆信息，了解车辆的详细情况。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="通行记录管理模块">
              <ol>
                <li>录入通行记录：工作人员可以录入车辆的通行记录，包括通行时间、地点和距离等。</li>
                <li>编辑通行记录：工作人员可以编辑通行记录，纠正录入错误或更新通行信息。</li>
                <li>查询通行记录：用户和工作人员可以查询通行记录，查看车辆的通行历史和详细信息。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="收费管理模块">
              <ol>
                <li>收费标准设定：管理员可以设置收费标准，包括不同车辆类型和通行距离的收费规定。</li>
                <li>计算通行费用：系统根据通行记录和收费标准计算通行费用，并提供给用户支付。</li>
                <li>支付通行费用：用户可以通过系统支付通行费用，确保费用及时到账。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="权限管理模块">
              <ol>
                <li>角色分配：管理员可以为用户和工作人员分配不同的角色，确定其拥有的功能权限。</li>
                <li>权限控制：系统根据用户角色和权限控制用户对系统功能的访问和操作权限。</li>
                <li>权限审核：管理员可以审核用户和工作人员的权限申请，确保权限分配合理和安全。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="作弊车辆处理模块">
              <ol>
                <li>作弊车辆监测：系统监测车辆是否存在作弊行为，如伪造车牌、不支付通行费用等。</li>
                <li>处理作弊记录：工作人员可以处理作弊记录，如暂停通行权限、罚款等，以维护系统秩序和公平性。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="数据统计与分析模块">
              <ol>
                <li>通行数据统计：系统对通行数据进行统计和分析，包括每日通行量、收费总额等，监控系统运行情况。</li>
                <li>数据报表生成：系统生成通行数据的报表和图表，支持用户查看和分析通行情况，进行决策和规划。</li>
              </ol>
            </el-collapse-item>
            <el-collapse-item title="反馈信息管理模块">
              <ol>
                <li>提交反馈信息：用户和工作人员可以向管理员提交反馈信息，包括系统使用体验、问题反馈等。</li>
                <li>查看反馈信息：管理员可以查看所有用户和工作人员提交的反馈信息，了解用户需求和系统问题。</li>
                <li>回复反馈信息：管理员可以回复用户和工作人员的反馈信息，提供帮助和解决方案，改善系统服务质量。</li>
              </ol>
            </el-collapse-item>

          </el-collapse>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="8">
        <el-card class="update-log">
          <div slot="header" class="clearfix">

          </div>
          <div class="body">

          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "Index",
  data() {
    return {
      // 版本号
      version: "3.8.7"
    };
  },
  methods: {
    goTarget(href) {
      window.open(href, "_blank");
    }
  }
};
</script>

<style scoped lang="scss">
.home {
  blockquote {
    padding: 10px 20px;
    margin: 0 0 20px;
    font-size: 17.5px;
    border-left: 5px solid #eee;
  }
  hr {
    margin-top: 20px;
    margin-bottom: 20px;
    border: 0;
    border-top: 1px solid #eee;
  }
  .col-item {
    margin-bottom: 20px;
  }

  ul {
    padding: 0;
    margin: 0;
  }

  font-family: "open sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 13px;
  color: #676a6c;
  overflow-x: hidden;

  ul {
    list-style-type: none;
  }

  h4 {
    margin-top: 0px;
  }

  h2 {
    margin-top: 10px;
    font-size: 26px;
    font-weight: 100;
  }

  p {
    margin-top: 10px;

    b {
      font-weight: 700;
    }
  }

  .update-log {
    ol {
      display: block;
      list-style-type: decimal;
      margin-block-start: 1em;
      margin-block-end: 1em;
      margin-inline-start: 0;
      margin-inline-end: 0;
      padding-inline-start: 40px;
    }
  }
}
</style>

