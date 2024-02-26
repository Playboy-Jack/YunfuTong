<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户ID" prop="UserID">
        <el-input
          v-model="queryParams.UserID"
          placeholder="请输入用户ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车牌号" prop="LicensePlate">
        <el-input
          v-model="queryParams.LicensePlate"
          placeholder="请输入车牌号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车辆类型" prop="VehicleType">
        <el-select v-model="queryParams.VehicleType" placeholder="请选择车辆类型" clearable>
          <el-option
            v-for="dict in dict.type.vehicletype"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="车辆品牌" prop="VehicleBrand">
        <el-input
          v-model="queryParams.VehicleBrand"
          placeholder="请输入车辆品牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车辆型号" prop="VehicleModel">
        <el-input
          v-model="queryParams.VehicleModel"
          placeholder="请输入车辆型号"
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
          v-hasPermi="['system:vehicles:add']"
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
          v-hasPermi="['system:vehicles:edit']"
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
          v-hasPermi="['system:vehicles:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:vehicles:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="vehiclesList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="车辆ID" align="center" prop="VehicleID" />
      <el-table-column label="用户ID" align="center" prop="UserID" />
      <el-table-column label="车牌号" align="center" prop="LicensePlate" />
      <el-table-column label="车辆类型" align="center" prop="VehicleType">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.vehicletype" :value="scope.row.VehicleType"/>
        </template>
      </el-table-column>
      <el-table-column label="车辆品牌" align="center" prop="VehicleBrand" />
      <el-table-column label="车辆型号" align="center" prop="VehicleModel" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:vehicles:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:vehicles:remove']"
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

    <!-- 添加或修改车辆信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="用户ID" prop="UserID">
          <el-input v-model="form.UserID" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="车牌号" prop="LicensePlate">
          <el-input v-model="form.LicensePlate" placeholder="请输入车牌号" />
        </el-form-item>
        <el-form-item label="车辆类型" prop="VehicleType">
          <el-select v-model="form.VehicleType" placeholder="请选择车辆类型">
            <el-option
              v-for="dict in dict.type.vehicletype"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="车辆品牌" prop="VehicleBrand">
          <el-input v-model="form.VehicleBrand" placeholder="请输入车辆品牌" />
        </el-form-item>
        <el-form-item label="车辆型号" prop="VehicleModel">
          <el-input v-model="form.VehicleModel" placeholder="请输入车辆型号" />
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
import { listVehicles, getVehicles, delVehicles, addVehicles, updateVehicles } from "@/api/system/vehicles";

export default {
  name: "Vehicles",
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
      // 车辆信息表格数据
      vehiclesList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        UserID: null,
        LicensePlate: null,
        VehicleType: null,
        VehicleBrand: null,
        VehicleModel: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        LicensePlate: [
          { required: true, message: "车牌号，唯一不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询车辆信息列表 */
    getList() {
      this.loading = true;
      listVehicles(this.queryParams).then(response => {
        this.vehiclesList = response.rows;
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
        VehicleID: null,
        UserID: null,
        LicensePlate: null,
        VehicleType: null,
        VehicleBrand: null,
        VehicleModel: null
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
      this.ids = selection.map(item => item.VehicleID)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加车辆信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const VehicleID = row.VehicleID || this.ids
      getVehicles(VehicleID).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改车辆信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.VehicleID != null) {
            updateVehicles(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addVehicles(this.form).then(response => {
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
      const VehicleIDs = row.VehicleID || this.ids;
      this.$modal.confirm('是否确认删除车辆信息编号为"' + VehicleIDs + '"的数据项？').then(function() {
        return delVehicles(VehicleIDs);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/vehicles/export', {
        ...this.queryParams
      }, `vehicles_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
