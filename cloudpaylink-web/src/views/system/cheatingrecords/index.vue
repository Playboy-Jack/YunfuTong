<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="通行记录ID" prop="transactionId" label-width="85px">
        <el-input
          v-model="queryParams.transactionId"
          placeholder="请输入通行记录ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="作弊类型" prop="cheatingType">
        <el-select v-model="queryParams.cheatingType" placeholder="请选择作弊类型" clearable>
          <el-option
            v-for="dict in dict.type.cheating_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="作弊检测时间" prop="detectionTime" label-width="100px">
        <el-date-picker clearable
          v-model="queryParams.detectionTime"
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="请选择作弊检测时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="处理状态" prop="handlingStatus">
        <el-select v-model="queryParams.handlingStatus" placeholder="请选择处理状态" clearable>
          <el-option
            v-for="dict in dict.type.handling_status"
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
          v-hasPermi="['system:cheatingrecords:add']"
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
          v-hasPermi="['system:cheatingrecords:edit']"
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
          v-hasPermi="['system:cheatingrecords:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:cheatingrecords:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="cheatingrecordsList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="作弊记录ID" align="center" prop="recordId" />
      <el-table-column label="通行记录ID" align="center" prop="transactionId" />
      <el-table-column label="作弊类型" align="center" prop="cheatingType">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.cheating_type" :value="scope.row.cheatingType"/>
        </template>
      </el-table-column>
      <el-table-column label="作弊检测时间" align="center" prop="detectionTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.detectionTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="处理状态" align="center" prop="handlingStatus">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.handling_status" :value="scope.row.handlingStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="处理细节" align="center" prop="handlingDetails" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:cheatingrecords:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:cheatingrecords:remove']"
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

    <!-- 添加或修改作弊记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="通行记录ID" prop="transactionId" label-width="85px">
          <el-input v-model="form.transactionId" placeholder="请输入通行记录ID" />
        </el-form-item>
        <el-form-item label="作弊类型" prop="cheatingType">
          <el-select v-model="form.cheatingType" placeholder="请选择作弊类型">
            <el-option
              v-for="dict in dict.type.cheating_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="检测时间" prop="detectionTime">
          <el-date-picker clearable
            v-model="form.detectionTime"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择作弊检测时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="处理状态" prop="handlingStatus">
          <el-radio-group v-model="form.handlingStatus">
            <el-radio-button
              v-for="dict in dict.type.handling_status"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理细节" prop="handlingDetails">
          <el-input v-model="form.handlingDetails" type="textarea" placeholder="请输入内容" />
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
import { listCheatingrecords, getCheatingrecords, delCheatingrecords, addCheatingrecords, updateCheatingrecords } from "@/api/system/cheatingrecords";

export default {
  name: "Cheatingrecords",
  dicts: ['handling_status', 'cheating_type'],
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
      // 作弊记录表格数据
      cheatingrecordsList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        transactionId: null,
        cheatingType: null,
        detectionTime: null,
        handlingStatus: null,
        handlingDetails: null
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
    /** 查询作弊记录列表 */
    getList() {
      this.loading = true;
      listCheatingrecords(this.queryParams).then(response => {
        this.cheatingrecordsList = response.rows;
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
        recordId: null,
        transactionId: null,
        cheatingType: null,
        detectionTime: null,
        handlingStatus: null,
        handlingDetails: null
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
      this.ids = selection.map(item => item.recordId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加作弊记录";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const recordId = row.recordId || this.ids
      getCheatingrecords(recordId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改作弊记录";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.recordId != null) {
            updateCheatingrecords(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCheatingrecords(this.form).then(response => {
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
      const recordIds = row.recordId || this.ids;
      this.$modal.confirm('是否确认删除作弊记录编号为"' + recordIds + '"的数据项？').then(function() {
        return delCheatingrecords(recordIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/cheatingrecords/export', {
        ...this.queryParams
      }, `cheatingrecords_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
