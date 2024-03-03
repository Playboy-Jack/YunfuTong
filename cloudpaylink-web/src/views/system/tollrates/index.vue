<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车辆类型" prop="vehicleType">
        <el-select v-model="queryParams.vehicleType" placeholder="请选择车辆类型" clearable>
          <el-option
            v-for="dict in dict.type.vehicletype"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="收费站ID" prop="tollboothId">
        <el-input
          v-model="queryParams.tollboothId"
          placeholder="请输入收费站ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车次基础费用" prop="baseFee">
        <el-input
          v-model="queryParams.baseFee"
          placeholder="请输入车次基础费用"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="每公里费用" prop="perKilometerFee">
        <el-input
          v-model="queryParams.perKilometerFee"
          placeholder="请输入每公里费用"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="费率生效日期" prop="validFrom">
        <el-date-picker clearable
          v-model="queryParams.validFrom"
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="请选择费率生效日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="费率截止日期" prop="validTo">
        <el-date-picker clearable
          v-model="queryParams.validTo"
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="请选择费率截止日期">
        </el-date-picker>
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
          v-hasPermi="['system:tollrates:add']"
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
          v-hasPermi="['system:tollrates:edit']"
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
          v-hasPermi="['system:tollrates:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:tollrates:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="tollratesList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="费率ID" align="center" prop="rateId" />
      <el-table-column label="车辆类型" align="center" prop="vehicleType">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.vehicletype" :value="scope.row.vehicleType"/>
        </template>
      </el-table-column>
      <el-table-column label="收费站ID" align="center" prop="tollboothId" />
      <el-table-column label="车次基础费用" align="center" prop="baseFee" />
      <el-table-column label="每公里费用" align="center" prop="perKilometerFee" />
      <el-table-column label="费率生效日期" align="center" prop="validFrom" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.validFrom, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="费率截止日期" align="center" prop="validTo" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.validTo, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:tollrates:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:tollrates:remove']"
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

    <!-- 添加或修改收费标准对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="车辆类型" prop="vehicleType">
          <el-select v-model="form.vehicleType" placeholder="请选择车辆类型">
            <el-option
              v-for="dict in dict.type.vehicletype"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="收费站ID" prop="tollboothId">
          <el-input v-model="form.tollboothId" placeholder="请输入收费站ID" />
        </el-form-item>
        <el-form-item label="车次基础费用" prop="baseFee">
          <el-input v-model="form.baseFee" placeholder="请输入车次基础费用" />
        </el-form-item>
        <el-form-item label="每公里费用" prop="perKilometerFee">
          <el-input v-model="form.perKilometerFee" placeholder="请输入每公里费用" />
        </el-form-item>
        <el-form-item label="费率生效日期" prop="validFrom">
          <el-date-picker clearable
            v-model="form.validFrom"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择费率生效日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="费率截止日期" prop="validTo">
          <el-date-picker clearable
            v-model="form.validTo"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择费率截止日期">
          </el-date-picker>
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
import { listTollrates, getTollrates, delTollrates, addTollrates, updateTollrates } from "@/api/system/tollrates";

export default {
  name: "Tollrates",
  dicts: ['vehicletype'],
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
      // 收费标准表格数据
      tollratesList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        vehicleType: null,
        tollboothId: null,
        baseFee: null,
        perKilometerFee: null,
        validFrom: null,
        validTo: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        vehicleType: [
          { required: true, message: "车辆类型不能为空", trigger: "change" }
        ],
        tollboothId: [
          { required: true, message: "收费站ID不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询收费标准列表 */
    getList() {
      this.loading = true;
      listTollrates(this.queryParams).then(response => {
        this.tollratesList = response.rows;
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
        rateId: null,
        vehicleType: null,
        tollboothId: null,
        baseFee: null,
        perKilometerFee: null,
        validFrom: null,
        validTo: null
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
      this.ids = selection.map(item => item.rateId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加收费标准";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const rateId = row.rateId || this.ids
      getTollrates(rateId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改收费标准";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.rateId != null) {
            updateTollrates(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTollrates(this.form).then(response => {
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
      const rateIds = row.rateId || this.ids;
      this.$modal.confirm('是否确认删除收费标准编号为"' + rateIds + '"的数据项？').then(function() {
        return delTollrates(rateIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/tollrates/export', {
        ...this.queryParams
      }, `tollrates_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
