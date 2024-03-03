<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="收费站名" prop="tollboothName">
        <el-input
          v-model="queryParams.tollboothName"
          placeholder="请输入收费站名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="收费站位置" prop="location" label-width="85px">
        <el-input
          v-model="queryParams.location"
          placeholder="请输入收费站位置"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="运营状态" prop="operationalStatus">
        <el-select v-model="queryParams.operationalStatus" placeholder="请选择运营状态" clearable>
          <el-option
            v-for="dict in dict.type.operationalstatus"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:tollbooths:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:tollbooths:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:tollbooths:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:tollbooths:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="tollboothsList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="收费站ID" align="center" prop="tollboothId" />
      <el-table-column label="收费站名" align="center" prop="tollboothName" />
      <el-table-column label="收费站位置" align="center" prop="location" />
      <el-table-column label="运营状态" align="center" prop="operationalStatus">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.operationalstatus" :value="scope.row.operationalStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:tollbooths:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:tollbooths:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改收费站管理对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="收费站名" prop="tollboothName">
          <el-input v-model="form.tollboothName" placeholder="请输入收费站名" />
        </el-form-item>
        <el-form-item label="收费站位置" prop="location" label-width="85px">
          <el-input v-model="form.location" placeholder="请输入收费站位置" />
        </el-form-item>
        <el-form-item label="运营状态" prop="operationalStatus">
          <el-radio-group v-model="form.operationalStatus">
            <el-radio
              v-for="dict in dict.type.operationalstatus"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTollbooths, getTollbooths, delTollbooths, addTollbooths, updateTollbooths } from "@/api/system/tollbooths";

export default {
  name: "Tollbooths",
  dicts: ['operationalstatus'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 收费站管理表格数据
      tollboothsList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tollboothName: null,
        location: null,
        operationalStatus: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询收费站管理列表 */
    getList() {
      this.loading = true;
      listTollbooths(this.queryParams).then(response => {
        this.tollboothsList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        tollboothId: null,
        tollboothName: null,
        location: null,
        operationalStatus: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.tollboothId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加收费站管理";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const tollboothId = row.tollboothId || this.ids
      getTollbooths(tollboothId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改收费站管理";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.tollboothId != null) {
            updateTollbooths(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTollbooths(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const tollboothIds = row.tollboothId || this.ids;
      this.$modal.confirm('是否确认删除收费站管理编号为"' + tollboothIds + '"的数据项？').then(function() {
        return delTollbooths(tollboothIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/tollbooths/export', {
        ...this.queryParams
      }, `tollbooths_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
