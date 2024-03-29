<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车辆ID" prop="vehicleId">
        <el-input
          v-model="queryParams.vehicleId"
          placeholder="请输入车辆ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="进入时间" prop="entryTime">
        <el-date-picker clearable
          v-model="queryParams.entryTime"
          type="datetime"
          value-format="yyyy-MM-dd hh:mm:ss"
          placeholder="请选择车辆进入时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="离开时间" prop="exitTime">
        <el-date-picker clearable
          v-model="queryParams.exitTime"
          type="datetime"
          value-format="yyyy-MM-dd hh:mm:ss"
          placeholder="请选择车辆离开时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="通行距离" prop="distance">
        <el-input
          v-model="queryParams.distance"
          placeholder="请输入通行距离"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="通行费用" prop="tollAmount">
        <el-input
          v-model="queryParams.tollAmount"
          placeholder="请输入通行费用"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="支付状态" prop="paymentStatus">
        <el-select v-model="queryParams.paymentStatus" placeholder="请选择支付状态" clearable>
          <el-option
            v-for="dict in dict.type.payment_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="收费站ID" prop="tollBoothId">
        <el-input
          v-model="queryParams.tollBoothId"
          placeholder="请输入收费站ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
          v-hasPermi="['system:transactions:add']"
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
          v-hasPermi="['system:transactions:edit']"
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
          v-hasPermi="['system:transactions:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:transactions:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="transactionsList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="通行记录ID" align="center" prop="transactionId" />
      <el-table-column label="车辆ID" align="center" prop="vehicleId" />
      <el-table-column label="车辆进入时间" align="center" prop="entryTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.entryTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="车辆离开时间" align="center" prop="exitTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.exitTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="通行距离" align="center" prop="distance" />
      <el-table-column label="通行费用" align="center" prop="tollAmount" />
      <el-table-column label="支付状态" align="center" prop="paymentStatus">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.payment_status" :value="scope.row.paymentStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="收费站ID" align="center" prop="tollBoothId" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:transactions:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:transactions:remove']"
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

    <!-- 添加或修改通行记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="车辆ID" prop="vehicleId">
          <el-input v-model="form.vehicleId" placeholder="请输入车辆ID" />
        </el-form-item>
        <el-form-item label="进入时间" prop="entryTime">
          <el-date-picker clearable
            v-model="form.entryTime"
            type="datetime"
            value-format="yyyy-MM-dd hh:mm:ss"
            placeholder="请选择车辆进入时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="离开时间" prop="exitTime">
          <el-date-picker clearable
            v-model="form.exitTime"
            type="datetime"
            value-format="yyyy-MM-dd hh:mm:ss"
            placeholder="请选择车辆离开时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="通行距离" prop="distance">
          <el-input v-model="form.distance" placeholder="请输入通行距离" />
        </el-form-item>
        <el-form-item label="通行费用" prop="tollAmount">
          <el-input v-model="form.tollAmount" placeholder="请输入通行费用" />
        </el-form-item>
        <el-form-item label="支付状态" prop="paymentStatus">
          <el-radio-group v-model="form.paymentStatus">
            <el-radio-button
              v-for="dict in dict.type.payment_status"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="收费站ID" prop="tollBoothId">
          <el-input v-model="form.tollBoothId" placeholder="请输入收费站ID" />
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
import { listTransactions, getTransactions, delTransactions, addTransactions, updateTransactions } from "@/api/system/transactions";

export default {
  name: "Transactions",
  dicts: ['payment_status'],
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
      // 通行记录表格数据
      transactionsList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        vehicleId: null,
        entryTime: null,
        exitTime: null,
        distance: null,
        tollAmount: null,
        paymentStatus: null,
        tollBoothId: null
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
    /** 查询通行记录列表 */
    getList() {
      this.loading = true;
      listTransactions(this.queryParams).then(response => {
        this.transactionsList = response.rows;
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
        transactionId: null,
        vehicleId: null,
        entryTime: null,
        exitTime: null,
        distance: null,
        tollAmount: null,
        paymentStatus: null,
        tollBoothId: null
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
      this.ids = selection.map(item => item.transactionId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加通行记录";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const transactionId = row.transactionId || this.ids
      getTransactions(transactionId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改通行记录";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.transactionId != null) {
            updateTransactions(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTransactions(this.form).then(response => {
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
      const transactionIds = row.transactionId || this.ids;
      this.$modal.confirm('是否确认删除通行记录编号为"' + transactionIds + '"的数据项？').then(function() {
        return delTransactions(transactionIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/transactions/export', {
        ...this.queryParams
      }, `transactions_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
