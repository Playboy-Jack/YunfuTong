/*
 Navicat Premium Data Transfer

 Source Server         : Windows
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44)
 Source Host           : localhost:3306
 Source Schema         : cloudpayment

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44)
 File Encoding         : 65001

 Date: 03/03/2024 23:55:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cp_cheatingrecords
-- ----------------------------
DROP TABLE IF EXISTS `cp_cheatingrecords`;
CREATE TABLE `cp_cheatingrecords`  (
  `record_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '作弊记录ID',
  `transaction_id` int(11) NOT NULL COMMENT '通行记录ID',
  `cheating_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '作弊类型',
  `detection_time` datetime NULL DEFAULT NULL COMMENT '作弊检测时间',
  `handling_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理状态',
  `handling_details` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '处理细节',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `transaction_id`(`transaction_id`) USING BTREE,
  CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '作弊记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_cheatingrecords
-- ----------------------------
INSERT INTO `cp_cheatingrecords` VALUES (3, 4, 'overspeed', '2024-03-03 00:00:00', 'processing', '超速行驶\n');

-- ----------------------------
-- Table structure for cp_feedback
-- ----------------------------
DROP TABLE IF EXISTS `cp_feedback`;
CREATE TABLE `cp_feedback`  (
  `feedback_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '反馈信息ID',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  `feedback_text` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '反馈内容',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '反馈时间戳',
  PRIMARY KEY (`feedback_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `cp_feedback_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '反馈信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_feedback
-- ----------------------------
INSERT INTO `cp_feedback` VALUES (1, 1, '系统内容不够丰富', '2024-03-03 00:00:00');

-- ----------------------------
-- Table structure for cp_tollbooths
-- ----------------------------
DROP TABLE IF EXISTS `cp_tollbooths`;
CREATE TABLE `cp_tollbooths`  (
  `tollbooth_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '收费站ID',
  `tollbooth_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收费站名',
  `location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收费站位置，唯一',
  `operational_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运营状态',
  PRIMARY KEY (`tollbooth_id`) USING BTREE,
  UNIQUE INDEX `location`(`location`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收费站表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_tollbooths
-- ----------------------------
INSERT INTO `cp_tollbooths` VALUES (1, '济南西站', '济南西边', '0');

-- ----------------------------
-- Table structure for cp_tollrates
-- ----------------------------
DROP TABLE IF EXISTS `cp_tollrates`;
CREATE TABLE `cp_tollrates`  (
  `rate_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '费率ID',
  `vehicle_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '车辆类型',
  `tollbooth_id` int(11) NOT NULL COMMENT '收费站ID',
  `base_fee` decimal(8, 2) NULL DEFAULT 10.00 COMMENT '车次基础费用',
  `per_kilometer_fee` decimal(8, 2) NULL DEFAULT 0.80 COMMENT '每公里费用',
  `valid_from` date NULL DEFAULT NULL COMMENT '费率生效日期',
  `valid_to` date NULL DEFAULT NULL COMMENT '费率截止日期',
  PRIMARY KEY (`rate_id`) USING BTREE,
  INDEX `vehicle_type`(`vehicle_type`) USING BTREE,
  INDEX `tollbooth_id`(`tollbooth_id`) USING BTREE,
  CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cp_tollrates_ibfk_2` FOREIGN KEY (`tollbooth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收费标准表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_tollrates
-- ----------------------------
INSERT INTO `cp_tollrates` VALUES (3, 'sedan', 1, 2.00, 8.00, '2024-03-03', '2024-03-03');
INSERT INTO `cp_tollrates` VALUES (5, 'sedan', 1, 10.00, 0.80, '2024-02-28', '2024-02-29');

-- ----------------------------
-- Table structure for cp_transactions
-- ----------------------------
DROP TABLE IF EXISTS `cp_transactions`;
CREATE TABLE `cp_transactions`  (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '通行记录ID',
  `vehicle_id` int(11) NULL DEFAULT NULL COMMENT '车辆ID，外键关联到车辆信息表的vehicle_id',
  `entry_time` datetime NULL DEFAULT NULL COMMENT '车辆进入时间',
  `exit_time` datetime NULL DEFAULT NULL COMMENT '车辆离开时间',
  `distance` float NULL DEFAULT NULL COMMENT '通行距离',
  `toll_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '通行费用',
  `payment_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付状态',
  `toll_booth_id` int(11) NULL DEFAULT NULL COMMENT '收费站ID',
  PRIMARY KEY (`transaction_id`) USING BTREE,
  INDEX `vehicle_id`(`vehicle_id`) USING BTREE,
  INDEX `toll_booth_id`(`toll_booth_id`) USING BTREE,
  CONSTRAINT `cp_transactions_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `cp_vehicles` (`vehicle_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通行记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_transactions
-- ----------------------------
INSERT INTO `cp_transactions` VALUES (4, 1, '2024-03-03 01:03:00', '2024-03-03 02:04:02', 1, 1.00, 'paid', 1);
INSERT INTO `cp_transactions` VALUES (5, 1, '2024-03-03 08:00:43', '2024-03-03 08:00:45', 2, 2.00, 'payment_failed', 1);

-- ----------------------------
-- Table structure for cp_vehicles
-- ----------------------------
DROP TABLE IF EXISTS `cp_vehicles`;
CREATE TABLE `cp_vehicles`  (
  `vehicle_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '车辆ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `license_plate` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '车牌号',
  `vehicle_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车辆类型',
  `vehicle_brand` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车辆品牌',
  `vehicle_model` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车辆型号',
  PRIMARY KEY (`vehicle_id`) USING BTREE,
  UNIQUE INDEX `license_plate`(`license_plate`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `vehicle_type`(`vehicle_type`) USING BTREE,
  CONSTRAINT `cp_vehicles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车辆信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_vehicles
-- ----------------------------
INSERT INTO `cp_vehicles` VALUES (1, 1, '鲁A00001', 'sedan', '奥迪', 'A8');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (5, 'cp_vehicles', '车辆信息表', NULL, NULL, 'CpVehicles', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'vehicles', '车辆信息', 'ruoyi', '0', '/', '{\"parentMenuId\":\"1061\"}', 'admin', '2024-02-26 21:52:42', '', '2024-03-03 00:25:51', NULL);
INSERT INTO `gen_table` VALUES (6, 'cp_tollbooths', '收费站表', NULL, NULL, 'CpTollbooths', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'tollbooths', '收费站管理', 'ruoyi', '0', '/', '{\"parentMenuId\":\"1063\"}', 'admin', '2024-03-02 20:34:11', '', '2024-03-03 13:31:20', NULL);
INSERT INTO `gen_table` VALUES (7, 'cp_feedback', '反馈信息表', NULL, NULL, 'CpFeedback', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'feedback', '反馈信息', 'ruoyi', '0', '/', '{\"parentMenuId\":\"1067\"}', 'admin', '2024-03-02 21:56:59', '', '2024-03-03 13:25:26', NULL);
INSERT INTO `gen_table` VALUES (8, 'cp_transactions', '通行记录表', NULL, NULL, 'CpTransactions', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'transactions', '通行记录', 'ruoyi', '0', '/', '{}', 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:19', NULL);
INSERT INTO `gen_table` VALUES (9, 'cp_cheatingrecords', '作弊记录表', NULL, NULL, 'CpCheatingrecords', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'cheatingrecords', '作弊记录', 'ruoyi', '0', '/', '{\"parentMenuId\":1065}', 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31', NULL);
INSERT INTO `gen_table` VALUES (10, 'cp_tollrates', '收费标准表', NULL, NULL, 'CpTollrates', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'tollrates', '收费标准', 'ruoyi', '0', '/', '{\"parentMenuId\":\"1063\"}', 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (38, 5, 'user_id', '用户ID', 'bigint(20)', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, '', '2024-03-02 22:34:30', '', '2024-03-03 00:25:51');
INSERT INTO `gen_table_column` VALUES (39, 5, 'vehicle_id', '车辆ID', 'int(11)', 'Long', 'vehicleId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, '', '2024-03-02 23:42:58', '', '2024-03-03 00:25:51');
INSERT INTO `gen_table_column` VALUES (40, 5, 'license_plate', '车牌号', 'varchar(20)', 'String', 'licensePlate', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, '', '2024-03-02 23:42:58', '', '2024-03-03 00:25:51');
INSERT INTO `gen_table_column` VALUES (41, 5, 'vehicle_type', '车辆类型', 'varchar(50)', 'String', 'vehicleType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'vehicletype', 4, '', '2024-03-02 23:42:58', '', '2024-03-03 00:25:51');
INSERT INTO `gen_table_column` VALUES (42, 5, 'vehicle_brand', '车辆品牌', 'varchar(255)', 'String', 'vehicleBrand', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, '', '2024-03-02 23:42:58', '', '2024-03-03 00:25:51');
INSERT INTO `gen_table_column` VALUES (43, 5, 'vehicle_model', '车辆型号', 'varchar(255)', 'String', 'vehicleModel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, '', '2024-03-02 23:42:58', '', '2024-03-03 00:25:51');
INSERT INTO `gen_table_column` VALUES (44, 6, 'tollbooth_id', '收费站ID', 'int(11)', 'Long', 'tollboothId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, '', '2024-03-02 23:42:59', '', '2024-03-03 13:31:20');
INSERT INTO `gen_table_column` VALUES (45, 6, 'tollbooth_name', '收费站名', 'varchar(255)', 'String', 'tollboothName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, '', '2024-03-02 23:42:59', '', '2024-03-03 13:31:20');
INSERT INTO `gen_table_column` VALUES (46, 6, 'location', '收费站位置，唯一', 'varchar(255)', 'String', 'location', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, '', '2024-03-02 23:42:59', '', '2024-03-03 13:31:20');
INSERT INTO `gen_table_column` VALUES (47, 6, 'operational_status', '运营状态', 'varchar(20)', 'String', 'operationalStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'operationalstatus', 4, '', '2024-03-02 23:42:59', '', '2024-03-03 13:31:20');
INSERT INTO `gen_table_column` VALUES (48, 7, 'feedback_id', '反馈信息ID', 'int(11)', 'Long', 'feedbackId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, '', '2024-03-02 23:44:06', '', '2024-03-03 13:25:26');
INSERT INTO `gen_table_column` VALUES (49, 7, 'user_id', '用户ID', 'bigint(20)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, '', '2024-03-02 23:44:06', '', '2024-03-03 13:25:26');
INSERT INTO `gen_table_column` VALUES (50, 7, 'feedback_text', '反馈内容', 'text', 'String', 'feedbackText', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 3, '', '2024-03-02 23:44:06', '', '2024-03-03 13:25:26');
INSERT INTO `gen_table_column` VALUES (51, 7, 'timestamp', '反馈时间', 'timestamp', 'Date', 'timestamp', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 4, '', '2024-03-02 23:44:06', '', '2024-03-03 13:25:26');
INSERT INTO `gen_table_column` VALUES (52, 8, 'transaction_id', '通行记录ID', 'int(11)', 'Long', 'transactionId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (53, 8, 'vehicle_id', '车辆ID', 'int(11)', 'Long', 'vehicleId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (54, 8, 'entry_time', '车辆进入时间', 'datetime', 'Date', 'entryTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 3, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (55, 8, 'exit_time', '车辆离开时间', 'datetime', 'Date', 'exitTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 4, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (56, 8, 'distance', '通行距离', 'float', 'Long', 'distance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (57, 8, 'toll_amount', '通行费用', 'decimal(10,2)', 'BigDecimal', 'tollAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (58, 8, 'payment_status', '支付状态', 'varchar(20)', 'String', 'paymentStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'payment_status', 7, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (59, 8, 'toll_booth_id', '收费站ID', 'int(11)', 'Long', 'tollBoothId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-03-03 15:13:45', '', '2024-03-03 15:17:20');
INSERT INTO `gen_table_column` VALUES (60, 9, 'record_id', '作弊记录ID', 'int(11)', 'Long', 'recordId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31');
INSERT INTO `gen_table_column` VALUES (61, 9, 'transaction_id', '通行记录ID', 'int(11)', 'Long', 'transactionId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31');
INSERT INTO `gen_table_column` VALUES (62, 9, 'cheating_type', '作弊类型', 'varchar(50)', 'String', 'cheatingType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'cheating_type', 3, 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31');
INSERT INTO `gen_table_column` VALUES (63, 9, 'detection_time', '作弊检测时间', 'datetime', 'Date', 'detectionTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 4, 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31');
INSERT INTO `gen_table_column` VALUES (64, 9, 'handling_status', '处理状态', 'varchar(20)', 'String', 'handlingStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'handling_status', 5, 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31');
INSERT INTO `gen_table_column` VALUES (65, 9, 'handling_details', '处理细节', 'text', 'String', 'handlingDetails', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 6, 'admin', '2024-03-03 22:31:35', '', '2024-03-03 22:34:31');
INSERT INTO `gen_table_column` VALUES (66, 10, 'rate_id', '费率ID', 'int(11)', 'Long', 'rateId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24');
INSERT INTO `gen_table_column` VALUES (68, 10, 'tollbooth_id', '收费站ID', 'int(11)', 'Long', 'tollboothId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24');
INSERT INTO `gen_table_column` VALUES (69, 10, 'base_fee', '车次基础费用', 'decimal(8,2)', 'BigDecimal', 'baseFee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24');
INSERT INTO `gen_table_column` VALUES (70, 10, 'per_kilometer_fee', '每公里费用', 'decimal(8,2)', 'BigDecimal', 'perKilometerFee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24');
INSERT INTO `gen_table_column` VALUES (71, 10, 'valid_from', '费率生效日期', 'date', 'Date', 'validFrom', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 6, 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24');
INSERT INTO `gen_table_column` VALUES (72, 10, 'valid_to', '费率截止日期', 'date', 'Date', 'validTo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 7, 'admin', '2024-03-03 23:34:12', '', '2024-03-03 23:44:24');
INSERT INTO `gen_table_column` VALUES (73, 10, 'vehicle_type', '车辆类型', 'varchar(50)', 'String', 'vehicleType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'vehicletype', 2, '', '2024-03-03 23:44:16', '', '2024-03-03 23:44:24');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-02-25 14:08:22', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-02-25 14:08:22', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-02-25 14:08:22', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-02-25 14:08:22', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-28 22:26:24', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-02-25 14:08:22', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '中国高速公路集团', 0, '中国', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-25 22:27:15');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '山东省高速公路集团', 1, '山东省', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-26 21:06:57');
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '陕西省高速公路集团', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-25 22:30:06');
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '济南市', 1, '济南', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-26 21:07:13');
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2024-02-25 14:08:22', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '青岛市', 3, '青岛', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-26 21:06:36');
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '淄博市', 4, '淄博', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-26 21:07:27');
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '枣庄市', 5, '枣庄', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-26 21:07:51');
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '西安市', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-25 22:30:27');
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '铜川市', 2, '铜川', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-26 21:08:31');
INSERT INTO `sys_dept` VALUES (110, 103, '0,100,101,103', '历下区', 1, '历下', '15888888888', 'lx@qq.com', '0', '0', 'admin', '2024-02-26 21:09:27', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (30, 0, '管理员', '0', 'roles_name', NULL, 'success', 'N', '0', 'admin', '2024-02-25 21:49:37', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (31, 0, '工作人员', '1', 'roles_name', NULL, 'warning', 'N', '0', 'admin', '2024-02-25 21:49:55', 'admin', '2024-02-25 21:50:30', NULL);
INSERT INTO `sys_dict_data` VALUES (32, 0, '用户', '2', 'roles_name', NULL, 'primary', 'N', '0', 'admin', '2024-02-25 21:50:12', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (33, 0, '轿车', 'sedan', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:20:20', 'admin', '2024-03-03 23:24:11', '通常是指乘用车，包括轿车、掀背车、两厢车等小型乘用车型。');
INSERT INTO `sys_dict_data` VALUES (35, 0, '大型客车', 'large_bus', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:21:08', 'admin', '2024-03-03 23:24:42', '用于运输乘客的大型客车，如长途客车、旅游巴士等。');
INSERT INTO `sys_dict_data` VALUES (36, 0, '货车', 'truck', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:21:30', 'admin', '2024-03-03 23:24:55', '用于货物运输的大型车辆，包括轻型、中型和重型卡车，以及载重卡车、自卸卡车等类型。');
INSERT INTO `sys_dict_data` VALUES (37, 0, '摩托车', 'motorcycle', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:21:49', 'admin', '2024-03-03 23:25:14', '两轮或三轮摩托车，通常用于个人代步或快递配送。');
INSERT INTO `sys_dict_data` VALUES (38, 0, '大型货车', 'large_truck', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:22:08', 'admin', '2024-03-03 23:25:40', '由载货车辆牵引的附属车辆，用于额外的货物运输或车辆运输。');
INSERT INTO `sys_dict_data` VALUES (39, 0, '特种车辆', 'special_vehicle', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:22:36', 'admin', '2024-03-03 23:25:55', '特定用途的车辆，如消防车、救护车、工程车等，通常具有特殊的行驶和停靠要求。');
INSERT INTO `sys_dict_data` VALUES (40, 0, '中小型客车', 'medium-sized_bus', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-02-26 21:30:15', 'admin', '2024-03-03 23:27:54', NULL);
INSERT INTO `sys_dict_data` VALUES (41, 0, '正常', '0', 'operationalstatus', NULL, 'success', 'N', '0', 'admin', '2024-03-02 20:37:55', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (42, 0, '停用', '1', 'operationalstatus', NULL, 'danger', 'N', '0', 'admin', '2024-03-02 20:38:21', 'admin', '2024-03-02 20:38:25', NULL);
INSERT INTO `sys_dict_data` VALUES (43, 0, '已支付', 'paid', 'payment_status', NULL, 'success', 'N', '0', 'admin', '2024-03-03 15:15:45', 'admin', '2024-03-03 22:20:52', NULL);
INSERT INTO `sys_dict_data` VALUES (44, 0, '待支付', 'pending', 'payment_status', NULL, 'primary', 'N', '0', 'admin', '2024-03-03 15:15:57', 'admin', '2024-03-03 22:22:43', '待支付：\n\n键值：pending\n描述：通行费用尚未支付。\n操作：车主或驾驶员需要支付通行费用。');
INSERT INTO `sys_dict_data` VALUES (45, 0, '超速', 'overspeed', 'cheating_type', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:11:11', '', NULL, '超速：\n\n键值：overspeed\n描述：车辆在高速公路上以超过规定速度行驶。\n行为特征：车速超过路段规定的限速标准。\n潜在影响：增加交通事故风险，危及交通安全');
INSERT INTO `sys_dict_data` VALUES (46, 0, '不按规定车道行驶', 'improper_lane_usage', 'cheating_type', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:11:49', '', NULL, '不按规定车道行驶：\n\n键值：improper_lane_usage\n描述：车辆在高速公路上未按照规定的车道行驶。\n行为特征：车辆在超车道、应急车道或不合适的车道行驶。\n潜在影响：引发交通拥堵和事故，影响其他车辆的通行安全。');
INSERT INTO `sys_dict_data` VALUES (47, 0, '虚报车辆类型', 'misreport_vehicle_type', 'cheating_type', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:12:18', '', NULL, '虚报车辆类型：\n\n键值：misreport_vehicle_type\n描述：车辆主人或驾驶员故意提供虚假的车辆类型信息。\n行为特征：车辆主人或驾驶员错误地声称车辆的类型，以减少通行费用。\n潜在影响：导致通行费用不准确，损害公共利益和交通管理秩序。');
INSERT INTO `sys_dict_data` VALUES (48, 0, '无效车牌', 'invalid_license_plate', 'cheating_type', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:12:43', '', NULL, '无效车牌：\n\n键值：invalid_license_plate\n描述：车辆使用无效或伪造的车牌。\n行为特征：车辆悬挂的车牌与法定要求不符或者是伪造的。\n潜在影响：难以对车辆进行追踪和管理，增加交通管理难度和风险。');
INSERT INTO `sys_dict_data` VALUES (49, 0, '逃费', 'toll_evasion', 'cheating_type', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:13:04', '', NULL, '逃费：\n\n键值：toll_evasion\n描述：车辆在收费站通过时故意逃避支付通行费用。\n行为特征：车辆未按规定的收费方式或通行规则通过收费站。\n潜在影响：导致通行费用损失，影响收费站的正常运营和资金收入。');
INSERT INTO `sys_dict_data` VALUES (50, 0, '伪造通行证', 'forged_pass', 'cheating_type', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:13:26', 'admin', '2024-03-03 22:13:31', '伪造通行证：\n\n键值：forged_pass\n描述：车辆主人或驾驶员使用伪造的通行证进行通行。\n行为特征：车辆使用伪造的通行证通过收费站或者路段。\n潜在影响：破坏通行管理秩序，损害收费管理的公平性和有效性。');
INSERT INTO `sys_dict_data` VALUES (51, 0, '未处理', 'unprocessed', 'handling_status', NULL, 'info', 'N', '0', 'admin', '2024-03-03 22:15:23', '', NULL, '未处理：\n\n键值：unprocessed\n描述：作弊记录尚未被处理。\n操作：待处理作弊记录。');
INSERT INTO `sys_dict_data` VALUES (52, 0, '处理中', 'processing', 'handling_status', NULL, 'default', 'N', '0', 'admin', '2024-03-03 22:15:50', 'admin', '2024-03-03 22:16:02', '处理中：\n\n键值：processing\n描述：作弊记录正在处理中。\n操作：处理人员正在对作弊记录进行审核和调查。');
INSERT INTO `sys_dict_data` VALUES (53, 0, '已处理', 'processed', 'handling_status', NULL, 'primary', 'N', '0', 'admin', '2024-03-03 22:16:23', 'admin', '2024-03-03 22:33:21', '已处理：\n\n键值：processed\n描述：作弊记录已经被处理。\n操作：对作弊行为进行了处理，例如罚款、警告或其他处罚措施。');
INSERT INTO `sys_dict_data` VALUES (55, 0, '无效', 'invalid', 'handling_status', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:17:18', 'admin', '2024-03-03 22:17:26', '无效：\n\n键值：invalid\n描述：作弊记录被认定为无效或不需要处理。\n操作：作弊记录被判定为误报或其他原因无需处理。');
INSERT INTO `sys_dict_data` VALUES (57, 0, '支付超时', 'payment_timeout', 'payment_status', NULL, 'warning', 'N', '0', 'admin', '2024-03-03 22:20:36', '', NULL, '支付超时：\n\n键值：payment_timeout\n描述：通行费用支付超时。\n操作：车主或驾驶员未在规定时间内完成支付。');
INSERT INTO `sys_dict_data` VALUES (58, 0, '支付失败', 'payment_failed', 'payment_status', NULL, 'danger', 'N', '0', 'admin', '2024-03-03 22:22:31', '', NULL, '支付失败：\n\n键值：payment_failed\n描述：通行费用支付失败。\n操作：支付操作未成功完成，可能由于支付信息错误、账户余额不足等原因导致。');
INSERT INTO `sys_dict_data` VALUES (59, 0, '小型车辆', 'compact_car', 'vehicletype', NULL, 'default', 'N', '0', 'admin', '2024-03-03 23:28:42', '', NULL, '描述：车身尺寸较小的小型汽车，适合在城市间通行和停车，通常收取普通车辆费率。');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (11, '用户角色', 'roles_name', '0', 'admin', '2024-02-25 21:48:32', '', NULL, '用户角色列表');
INSERT INTO `sys_dict_type` VALUES (12, '车辆类型', 'vehicletype', '0', 'admin', '2024-02-26 21:19:07', '', NULL, '轿车 / 小型车：通常是指乘用车，包括轿车、掀背车、两厢车等小型乘用车型。\nSUV / 大型车：运动型多用途车或大型乘用车，具有较大的车身尺寸和排量。\n客车 / 大型客车：用于运输乘客的大型客车，如长途客车、旅游巴士等。\n卡车 / 货车：用于货物运输的大型车辆，包括轻型、中型和重型卡车，以及载重卡车、自卸卡车等类型。\n摩托车：两轮或三轮摩托车，通常用于个人代步或快递配送。\n拖挂车 / 挂车：由载货车辆牵引的附属车辆，用于额外的货物运输或车辆运输。\n公交车：城市公共交通车辆，用于运输大量乘客。\n特种车辆：特定用途的车辆，如消防车、救护车、工程车等，通常具有特殊的行驶和停靠要求。');
INSERT INTO `sys_dict_type` VALUES (13, '收费站运营状态', 'operationalstatus', '0', 'admin', '2024-03-02 20:36:18', 'admin', '2024-03-03 22:24:14', '收费站运营状态\n\n');
INSERT INTO `sys_dict_type` VALUES (15, '支付状态', 'payment_status', '0', 'admin', '2024-03-03 15:15:12', 'admin', '2024-03-03 22:23:59', '支付状态\n');
INSERT INTO `sys_dict_type` VALUES (16, '作弊类型', 'cheating_type', '0', 'admin', '2024-03-03 22:10:03', 'admin', '2024-03-03 22:10:22', '汽车高速违规类型\n');
INSERT INTO `sys_dict_type` VALUES (17, '处理状态', 'handling_status', '0', 'admin', '2024-03-03 22:14:02', 'admin', '2024-03-03 22:14:18', '作弊处理状态');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-02-25 14:08:22', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-25 17:41:21');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-25 20:54:31');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-02-25 21:44:52');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-25 21:44:57');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-25 23:17:20');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-26 20:54:01');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-02-28 21:45:47');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-28 21:45:50');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-28 22:25:34');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-28 22:25:43');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-28 22:26:28');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-28 22:26:37');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-28 22:27:17');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-28 22:27:29');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-28 22:29:46');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-28 22:29:53');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-29 20:56:34');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-29 21:47:01');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-29 21:47:10');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-29 22:03:32');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-02-29 22:10:37');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-29 22:10:42');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-02-29 22:14:48');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码已失效', '2024-02-29 23:13:11');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-02-29 23:13:17');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-02 19:25:21');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-03-02 20:11:08');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-02 20:11:13');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-03-02 21:54:34');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-02 21:54:37');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-02 23:42:49');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 00:14:37');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 00:25:12');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 13:15:06');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 15:12:26');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 16:03:19');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 18:28:24');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 19:27:23');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-03-03 19:29:04');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 19:29:08');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-03-03 21:47:42');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-03-03 21:47:50');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1134 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 0, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-25 22:22:38', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-02-25 14:08:22', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-02-25 14:08:22', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-02-25 14:08:22', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-02-25 14:08:22', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-02-25 14:08:22', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-02-25 14:08:22', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-02-25 14:08:22', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-02-25 14:08:22', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-02-25 14:08:22', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-02-25 14:08:22', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 0, 4, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-29 23:22:22', '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-02-25 14:08:22', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-02-25 14:08:22', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-02-25 14:08:22', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-02-25 14:08:22', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-02-25 14:08:22', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-02-25 14:08:22', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-02-25 14:08:22', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-02-25 14:08:22', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-02-25 14:08:22', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-02-25 14:08:22', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-02-25 14:08:22', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1061, '车辆管理', 0, 0, 'Vehicles', NULL, NULL, 1, 0, 'M', '0', '0', '', '车辆管理', 'admin', '2024-02-25 21:55:43', 'admin', '2024-03-03 13:23:15', '');
INSERT INTO `sys_menu` VALUES (1062, '通行记录', 0, 0, 'Transactions', NULL, NULL, 1, 0, 'M', '0', '0', '', 'documentation', 'admin', '2024-02-25 21:57:44', 'admin', '2024-02-29 23:23:33', '');
INSERT INTO `sys_menu` VALUES (1063, '收费管理', 0, 0, 'TollRates', NULL, NULL, 1, 0, 'M', '0', '0', '', 'money', 'admin', '2024-02-25 21:59:14', 'admin', '2024-02-29 23:17:18', '');
INSERT INTO `sys_menu` VALUES (1065, '作弊管理', 0, 0, 'CheatingRecords', NULL, NULL, 1, 0, 'M', '0', '0', '', 'eye-open', 'admin', '2024-02-25 22:01:12', 'admin', '2024-03-03 19:30:44', '');
INSERT INTO `sys_menu` VALUES (1067, '反馈管理', 0, 0, 'Feedback', NULL, NULL, 1, 0, 'M', '0', '0', '', 'email', 'admin', '2024-02-25 22:04:33', 'admin', '2024-02-26 21:36:36', '');
INSERT INTO `sys_menu` VALUES (1092, '车辆信息', 1061, 1, 'vehicles', 'system/vehicles/index', NULL, 1, 0, 'C', '0', '0', 'system:vehicles:list', '车辆信息', 'admin', '2024-03-02 23:46:45', 'admin', '2024-03-03 13:21:26', '车辆信息菜单');
INSERT INTO `sys_menu` VALUES (1093, '车辆信息查询', 1092, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:vehicles:query', '#', 'admin', '2024-03-02 23:46:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1094, '车辆信息新增', 1092, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:vehicles:add', '#', 'admin', '2024-03-02 23:46:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1095, '车辆信息修改', 1092, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:vehicles:edit', '#', 'admin', '2024-03-02 23:46:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1096, '车辆信息删除', 1092, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:vehicles:remove', '#', 'admin', '2024-03-02 23:46:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1097, '车辆信息导出', 1092, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:vehicles:export', '#', 'admin', '2024-03-02 23:46:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1098, '反馈信息', 1067, 1, 'feedback', 'system/feedback/index', NULL, 1, 0, 'C', '0', '0', 'system:feedback:list', '反馈信息', 'admin', '2024-03-03 13:25:54', 'admin', '2024-03-03 13:29:07', '反馈信息菜单');
INSERT INTO `sys_menu` VALUES (1099, '反馈信息查询', 1098, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:feedback:query', '#', 'admin', '2024-03-03 13:25:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1100, '反馈信息新增', 1098, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:feedback:add', '#', 'admin', '2024-03-03 13:25:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1101, '反馈信息修改', 1098, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:feedback:edit', '#', 'admin', '2024-03-03 13:25:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1102, '反馈信息删除', 1098, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:feedback:remove', '#', 'admin', '2024-03-03 13:25:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1103, '反馈信息导出', 1098, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:feedback:export', '#', 'admin', '2024-03-03 13:25:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1104, '收费站信息', 1063, 1, 'tollbooths', 'system/tollbooths/index', NULL, 1, 0, 'C', '0', '0', 'system:tollbooths:list', '收费站管理', 'admin', '2024-03-03 13:32:12', 'admin', '2024-03-03 21:48:45', '收费站管理菜单');
INSERT INTO `sys_menu` VALUES (1105, '收费站管理查询', 1104, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollbooths:query', '#', 'admin', '2024-03-03 13:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1106, '收费站管理新增', 1104, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollbooths:add', '#', 'admin', '2024-03-03 13:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1107, '收费站管理修改', 1104, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollbooths:edit', '#', 'admin', '2024-03-03 13:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1108, '收费站管理删除', 1104, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollbooths:remove', '#', 'admin', '2024-03-03 13:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1109, '收费站管理导出', 1104, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollbooths:export', '#', 'admin', '2024-03-03 13:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1110, '通行记录', 1062, 1, 'transactions', 'system/transactions/index', NULL, 1, 0, 'C', '0', '0', 'system:transactions:list', '通行记录', 'admin', '2024-03-03 15:31:49', 'admin', '2024-03-03 19:31:36', '通行记录菜单');
INSERT INTO `sys_menu` VALUES (1111, '通行记录查询', 1110, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:transactions:query', '#', 'admin', '2024-03-03 15:31:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1112, '通行记录新增', 1110, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:transactions:add', '#', 'admin', '2024-03-03 15:31:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1113, '通行记录修改', 1110, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:transactions:edit', '#', 'admin', '2024-03-03 15:31:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1114, '通行记录删除', 1110, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:transactions:remove', '#', 'admin', '2024-03-03 15:31:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1115, '通行记录导出', 1110, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:transactions:export', '#', 'admin', '2024-03-03 15:31:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1116, '作弊记录', 1065, 1, 'cheatingrecords', 'system/cheatingrecords/index', NULL, 1, 0, 'C', '0', '0', 'system:cheatingrecords:list', '作弊记录', 'admin', '2024-03-03 22:35:04', 'admin', '2024-03-03 23:01:33', '作弊记录菜单');
INSERT INTO `sys_menu` VALUES (1117, '作弊记录查询', 1116, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cheatingrecords:query', '#', 'admin', '2024-03-03 22:35:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1118, '作弊记录新增', 1116, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cheatingrecords:add', '#', 'admin', '2024-03-03 22:35:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1119, '作弊记录修改', 1116, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cheatingrecords:edit', '#', 'admin', '2024-03-03 22:35:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1120, '作弊记录删除', 1116, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cheatingrecords:remove', '#', 'admin', '2024-03-03 22:35:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1121, '作弊记录导出', 1116, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cheatingrecords:export', '#', 'admin', '2024-03-03 22:35:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1128, '收费标准', 1063, 1, 'tollrates', 'system/tollrates/index', NULL, 1, 0, 'C', '0', '0', 'system:tollrates:list', '#', 'admin', '2024-03-03 23:46:02', '', NULL, '收费标准菜单');
INSERT INTO `sys_menu` VALUES (1129, '收费标准查询', 1128, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollrates:query', '#', 'admin', '2024-03-03 23:46:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1130, '收费标准新增', 1128, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollrates:add', '#', 'admin', '2024-03-03 23:46:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1131, '收费标准修改', 1128, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollrates:edit', '#', 'admin', '2024-03-03 23:46:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1132, '收费标准删除', 1128, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollrates:remove', '#', 'admin', '2024-03-03 23:46:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1133, '收费标准导出', 1128, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tollrates:export', '#', 'admin', '2024-03-03 23:46:02', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2024-02-25 14:08:22', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2024-02-25 14:08:22', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 262 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"用户角色\",\"dictType\":\"roles_name\",\"params\":{},\"remark\":\"用户角色列表\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:48:32', 12);
INSERT INTO `sys_oper_log` VALUES (2, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"管理员\",\"dictSort\":0,\"dictType\":\"roles_name\",\"dictValue\":\"0\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:49:37', 4);
INSERT INTO `sys_oper_log` VALUES (3, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"工作人员\",\"dictSort\":0,\"dictType\":\"roles_name\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:49:55', 3);
INSERT INTO `sys_oper_log` VALUES (4, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"用户\",\"dictSort\":0,\"dictType\":\"roles_name\",\"dictValue\":\"2\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:50:12', 3);
INSERT INTO `sys_oper_log` VALUES (5, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-25 21:49:55\",\"default\":false,\"dictCode\":31,\"dictLabel\":\"工作人员\",\"dictSort\":0,\"dictType\":\"roles_name\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"info\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:50:24', 6);
INSERT INTO `sys_oper_log` VALUES (6, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-25 21:49:55\",\"default\":false,\"dictCode\":31,\"dictLabel\":\"工作人员\",\"dictSort\":0,\"dictType\":\"roles_name\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:50:30', 6);
INSERT INTO `sys_oper_log` VALUES (7, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"车辆管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Vehicles\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:55:43', 7);
INSERT INTO `sys_oper_log` VALUES (8, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 14:08:22\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"系统官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:56:46', 8);
INSERT INTO `sys_oper_log` VALUES (9, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"通行记录\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Transactions\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:57:44', 4);
INSERT INTO `sys_oper_log` VALUES (10, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"收费管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"TollRates\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 21:59:14', 3);
INSERT INTO `sys_oper_log` VALUES (11, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"权限管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Permissions\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:00:20', 4);
INSERT INTO `sys_oper_log` VALUES (12, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"作弊车辆管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"CheatingRecords\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:01:12', 5);
INSERT INTO `sys_oper_log` VALUES (13, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:01:12\",\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1065,\"menuName\":\"作弊管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"CheatingRecords\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:01:29', 6);
INSERT INTO `sys_oper_log` VALUES (14, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"统计管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Datastatistics\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:04:03', 7);
INSERT INTO `sys_oper_log` VALUES (15, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"反馈管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Feedback\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:04:33', 6);
INSERT INTO `sys_oper_log` VALUES (16, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 14:08:22\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:22:38', 6);
INSERT INTO `sys_oper_log` VALUES (17, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"中国高速公路\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:25:22', 12);
INSERT INTO `sys_oper_log` VALUES (18, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"中国高速公路有限责任公司\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:26:11', 6);
INSERT INTO `sys_oper_log` VALUES (19, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"中国高速公路集团\",\"email\":\"ry@qq.com\",\"leader\":\"中国\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:27:15', 6);
INSERT INTO `sys_oper_log` VALUES (20, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"省级高速公路集团\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"中国高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:27:48', 141);
INSERT INTO `sys_oper_log` VALUES (21, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"山东省\",\"email\":\"ry@qq.com\",\"leader\":\"山东\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"parentName\":\"省级高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:28:11', 3);
INSERT INTO `sys_oper_log` VALUES (22, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/104', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:28:14', 6);
INSERT INTO `sys_oper_log` VALUES (23, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/105', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"部门存在用户,不允许删除\",\"code\":601}', 0, NULL, '2024-02-25 22:28:16', 5);
INSERT INTO `sys_oper_log` VALUES (24, '部门管理', 3, 'com.ruoyi.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/105', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"部门存在用户,不允许删除\",\"code\":601}', 0, NULL, '2024-02-25 22:28:34', 5);
INSERT INTO `sys_oper_log` VALUES (25, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"山东省高速公路集团\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"中国高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:29:24', 5);
INSERT INTO `sys_oper_log` VALUES (26, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"济南市高速公路\",\"email\":\"ry@qq.com\",\"leader\":\"山东\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"parentName\":\"山东省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:29:40', 4);
INSERT INTO `sys_oper_log` VALUES (27, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":102,\"deptName\":\"陕西省高速公路集团\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"parentName\":\"中国高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:30:06', 4);
INSERT INTO `sys_oper_log` VALUES (28, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102\",\"children\":[],\"deptId\":108,\"deptName\":\"西安市\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":102,\"parentName\":\"陕西省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:30:27', 6);
INSERT INTO `sys_oper_log` VALUES (29, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"济南市\",\"email\":\"ry@qq.com\",\"leader\":\"山东\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"parentName\":\"山东省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 22:30:34', 0);
INSERT INTO `sys_oper_log` VALUES (30, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"users\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 23:20:53', 17);
INSERT INTO `sys_oper_log` VALUES (31, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"users\",\"className\":\"Users\",\"columns\":[{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID\",\"columnId\":1,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Username\",\"columnComment\":\"用户名，用于登录\",\"columnId\":2,\"columnName\":\"Username\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"Username\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Password\",\"columnComment\":\"密码，用于登录\",\"columnId\":3,\"columnName\":\"Password\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"Password\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Email\",\"columnComment\":\"用户邮箱地址\",\"columnId\":4,\"columnName\":\"Email\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-25 23:21:17', 17);
INSERT INTO `sys_oper_log` VALUES (32, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"users\",\"className\":\"Users\",\"columns\":[{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID\",\"columnId\":1,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2024-02-25 23:21:17\",\"usableColumn\":false},{\"capJavaField\":\"Username\",\"columnComment\":\"用户名，用于登录\",\"columnId\":2,\"columnName\":\"Username\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"Username\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2024-02-25 23:21:17\",\"usableColumn\":false},{\"capJavaField\":\"Password\",\"columnComment\":\"密码，用于登录\",\"columnId\":3,\"columnName\":\"Password\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"Password\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2024-02-25 23:21:17\",\"usableColumn\":false},{\"capJavaField\":\"Email\",\"columnComment\":\"用户邮箱地址\",\"columnId\":4,\"columnName\":\"Email\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 23:20:53\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":t', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 20:58:02', 28);
INSERT INTO `sys_oper_log` VALUES (33, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":105,\"deptName\":\"青岛市\",\"email\":\"ry@qq.com\",\"leader\":\"青岛\",\"orderNum\":3,\"params\":{},\"parentId\":101,\"parentName\":\"山东省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:06:36', 12);
INSERT INTO `sys_oper_log` VALUES (34, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"山东省高速公路集团\",\"email\":\"ry@qq.com\",\"leader\":\"山东省\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"中国高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:06:57', 12);
INSERT INTO `sys_oper_log` VALUES (35, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"济南市\",\"email\":\"ry@qq.com\",\"leader\":\"济南\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"parentName\":\"山东省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:07:13', 5);
INSERT INTO `sys_oper_log` VALUES (36, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":106,\"deptName\":\"淄博市\",\"email\":\"ry@qq.com\",\"leader\":\"淄博\",\"orderNum\":4,\"params\":{},\"parentId\":101,\"parentName\":\"山东省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:07:27', 12);
INSERT INTO `sys_oper_log` VALUES (37, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":107,\"deptName\":\"枣庄市\",\"email\":\"ry@qq.com\",\"leader\":\"枣庄\",\"orderNum\":5,\"params\":{},\"parentId\":101,\"parentName\":\"山东省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:07:51', 12);
INSERT INTO `sys_oper_log` VALUES (38, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102\",\"children\":[],\"deptId\":109,\"deptName\":\"铜川市\",\"email\":\"ry@qq.com\",\"leader\":\"铜川\",\"orderNum\":2,\"params\":{},\"parentId\":102,\"parentName\":\"陕西省高速公路集团\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:08:31', 12);
INSERT INTO `sys_oper_log` VALUES (39, '部门管理', 1, 'com.ruoyi.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '济南市', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"历下区\",\"email\":\"lx@qq.com\",\"leader\":\"历下\",\"orderNum\":1,\"params\":{},\"parentId\":103,\"phone\":\"15888888888\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:09:27', 5);
INSERT INTO `sys_oper_log` VALUES (40, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"车辆类型\",\"dictType\":\"vehicletype\",\"params\":{},\"remark\":\"轿车 / 小型车：通常是指乘用车，包括轿车、掀背车、两厢车等小型乘用车型。\\nSUV / 大型车：运动型多用途车或大型乘用车，具有较大的车身尺寸和排量。\\n客车 / 大型客车：用于运输乘客的大型客车，如长途客车、旅游巴士等。\\n卡车 / 货车：用于货物运输的大型车辆，包括轻型、中型和重型卡车，以及载重卡车、自卸卡车等类型。\\n摩托车：两轮或三轮摩托车，通常用于个人代步或快递配送。\\n拖挂车 / 挂车：由载货车辆牵引的附属车辆，用于额外的货物运输或车辆运输。\\n公交车：城市公共交通车辆，用于运输大量乘客。\\n特种车辆：特定用途的车辆，如消防车、救护车、工程车等，通常具有特殊的行驶和停靠要求。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:19:07', 6);
INSERT INTO `sys_oper_log` VALUES (41, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"小型车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"remark\":\"通常是指乘用车，包括轿车、掀背车、两厢车等小型乘用车型。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:20:20', 5);
INSERT INTO `sys_oper_log` VALUES (42, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"大型车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"remark\":\"运动型多用途车或大型乘用车，具有较大的车身尺寸和排量\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:20:45', 5);
INSERT INTO `sys_oper_log` VALUES (43, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"大型客车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"remark\":\"用于运输乘客的大型客车，如长途客车、旅游巴士等。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:21:08', 6);
INSERT INTO `sys_oper_log` VALUES (44, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"货车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"remark\":\"用于货物运输的大型车辆，包括轻型、中型和重型卡车，以及载重卡车、自卸卡车等类型。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:21:30', 5);
INSERT INTO `sys_oper_log` VALUES (45, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"摩托车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"4\",\"listClass\":\"default\",\"params\":{},\"remark\":\"两轮或三轮摩托车，通常用于个人代步或快递配送。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:21:49', 5);
INSERT INTO `sys_oper_log` VALUES (46, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"挂车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"5\",\"listClass\":\"default\",\"params\":{},\"remark\":\"由载货车辆牵引的附属车辆，用于额外的货物运输或车辆运输。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:22:08', 0);
INSERT INTO `sys_oper_log` VALUES (47, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"特种车辆\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"6\",\"listClass\":\"default\",\"params\":{},\"remark\":\"特定用途的车辆，如消防车、救护车、工程车等，通常具有特殊的行驶和停靠要求。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:22:36', 6);
INSERT INTO `sys_oper_log` VALUES (48, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:20:20\",\"default\":false,\"dictCode\":33,\"dictLabel\":\"轿车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"0\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"通常是指乘用车，包括轿车、掀背车、两厢车等小型乘用车型。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:22:47', 7);
INSERT INTO `sys_oper_log` VALUES (49, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:20:45\",\"default\":false,\"dictCode\":34,\"dictLabel\":\"SUV\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"运动型多用途车或大型乘用车，具有较大的车身尺寸和排量\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:23:03', 7);
INSERT INTO `sys_oper_log` VALUES (50, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"面包车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"7\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:30:15', 11);
INSERT INTO `sys_oper_log` VALUES (51, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"vehicles\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:31:50', 20);
INSERT INTO `sys_oper_log` VALUES (52, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '济南市', '/tool/gen/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:32:39', 6);
INSERT INTO `sys_oper_log` VALUES (53, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"vehicles\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:32:46', 29);
INSERT INTO `sys_oper_log` VALUES (54, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '济南市', '/tool/gen/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:34:45', 7);
INSERT INTO `sys_oper_log` VALUES (55, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"vehicles\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:34:48', 13);
INSERT INTO `sys_oper_log` VALUES (56, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"Vehicles\",\"columns\":[{\"capJavaField\":\"VehicleID\",\"columnComment\":\"车辆ID\",\"columnId\":18,\"columnName\":\"VehicleID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"VehicleID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID，外键关联到用户表的UserID\",\"columnId\":19,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号，唯一\",\"columnId\":20,\"columnName\":\"LicensePlate\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"LicensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":21,\"columnName\":\"VehicleType\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"vehicletype\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:35:08', 12);
INSERT INTO `sys_oper_log` VALUES (57, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"Vehicles\",\"columns\":[{\"capJavaField\":\"VehicleID\",\"columnComment\":\"车辆ID\",\"columnId\":18,\"columnName\":\"VehicleID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"VehicleID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2024-02-26 21:35:08\",\"usableColumn\":false},{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID，外键关联到用户表的UserID\",\"columnId\":19,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2024-02-26 21:35:08\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号，唯一\",\"columnId\":20,\"columnName\":\"LicensePlate\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"LicensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2024-02-26 21:35:08\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":21,\"columnName\":\"VehicleType\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:34:48\",\"dictType\":\"vehicletype\",\"edit\":true,', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:35:34', 7);
INSERT INTO `sys_oper_log` VALUES (58, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:04:33\",\"icon\":\"email\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1067,\"menuName\":\"反馈管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Feedback\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:36:36', 6);
INSERT INTO `sys_oper_log` VALUES (59, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"vehicles\"}', NULL, 0, NULL, '2024-02-26 21:37:25', 111);
INSERT INTO `sys_oper_log` VALUES (60, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"vehicles\"}', NULL, 0, NULL, '2024-02-26 21:37:25', 24);
INSERT INTO `sys_oper_log` VALUES (61, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '济南市', '/tool/gen/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:52:17', 8);
INSERT INTO `sys_oper_log` VALUES (62, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '济南市', '/tool/gen/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:52:19', 7);
INSERT INTO `sys_oper_log` VALUES (63, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 21:52:42', 15);
INSERT INTO `sys_oper_log` VALUES (64, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"CpVehicles\",\"columns\":[{\"capJavaField\":\"VehicleID\",\"columnComment\":\"车辆ID\",\"columnId\":24,\"columnName\":\"VehicleID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"VehicleID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID，外键关联到用户表的UserID\",\"columnId\":25,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号，唯一\",\"columnId\":26,\"columnName\":\"LicensePlate\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"LicensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":27,\"columnName\":\"VehicleType\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"vehicletype\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isLi', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:01:57', 3);
INSERT INTO `sys_oper_log` VALUES (65, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-02-26 22:02:00', 26);
INSERT INTO `sys_oper_log` VALUES (66, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/vehicles/index\",\"createTime\":\"2024-02-26 22:02:29\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1068,\"menuName\":\"车辆信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1061,\"path\":\"vehicles\",\"perms\":\"system:vehicles:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:20:38', 13);
INSERT INTO `sys_oper_log` VALUES (67, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"CpVehicles\",\"columns\":[{\"capJavaField\":\"VehicleID\",\"columnComment\":\"车辆ID\",\"columnId\":24,\"columnName\":\"VehicleID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"VehicleID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-02-26 22:01:57\",\"usableColumn\":false},{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID，外键关联到用户表的UserID\",\"columnId\":25,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-02-26 22:01:57\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号，唯一\",\"columnId\":26,\"columnName\":\"LicensePlate\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"LicensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-02-26 22:01:57\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":27,\"columnName\":\"VehicleType\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"vehicletype\",\"edit\":tru', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:26:17', 18);
INSERT INTO `sys_oper_log` VALUES (68, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-02-26 22:26:22', 129);
INSERT INTO `sys_oper_log` VALUES (69, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1074', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2024-02-26 22:28:32', 5);
INSERT INTO `sys_oper_log` VALUES (70, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1075', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:28:43', 7);
INSERT INTO `sys_oper_log` VALUES (71, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1076', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:28:49', 6);
INSERT INTO `sys_oper_log` VALUES (72, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1078', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:28:52', 6);
INSERT INTO `sys_oper_log` VALUES (73, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1077', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:28:55', 6);
INSERT INTO `sys_oper_log` VALUES (74, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1079', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:28:57', 7);
INSERT INTO `sys_oper_log` VALUES (75, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1074', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:28:59', 6);
INSERT INTO `sys_oper_log` VALUES (76, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1081', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:29:03', 7);
INSERT INTO `sys_oper_log` VALUES (77, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1082', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:29:06', 5);
INSERT INTO `sys_oper_log` VALUES (78, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1083', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:29:07', 7);
INSERT INTO `sys_oper_log` VALUES (79, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1084', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:29:11', 0);
INSERT INTO `sys_oper_log` VALUES (80, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1085', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:29:13', 7);
INSERT INTO `sys_oper_log` VALUES (81, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1080', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-26 22:29:15', 6);
INSERT INTO `sys_oper_log` VALUES (82, '车辆信息', 5, 'com.ruoyi.system.controller.CpVehiclesController.export()', 'POST', 1, 'admin', '济南市', '/system/vehicles/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-02-26 22:32:28', 365);
INSERT INTO `sys_oper_log` VALUES (83, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '济南市', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ry@163.com\",\"nickName\":\"管理员\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 21:48:50', 7);
INSERT INTO `sys_oper_log` VALUES (84, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 21:55:43\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"车辆管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Vehicles\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 21:50:39', 28);
INSERT INTO `sys_oper_log` VALUES (85, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '济南市', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":101,\"nickName\":\"工作人员\",\"params\":{},\"phonenumber\":\"15777777777\",\"postIds\":[4],\"roleIds\":[3],\"sex\":\"0\",\"status\":\"0\",\"userId\":3,\"userName\":\"worker\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:15:26', 93);
INSERT INTO `sys_oper_log` VALUES (86, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '济南市', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2024-02-28 22:15:26\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"山东省高速公路集团\",\"leader\":\"山东省\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"status\":\"0\"},\"deptId\":106,\"email\":\"ry@123.com\",\"loginDate\":\"2024-02-28 22:16:29\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"工作人员\",\"params\":{},\"phonenumber\":\"15777777777\",\"postIds\":[4],\"remark\":\"工作人员\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"worker\",\"roleName\":\"工作人员\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":3,\"userName\":\"worker\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:17:26', 16);
INSERT INTO `sys_oper_log` VALUES (87, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '济南市', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-25 14:08:22\",\"flag\":false,\"params\":{},\"postCode\":\"admin\",\"postId\":1,\"postName\":\"管理员\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:18:02', 10);
INSERT INTO `sys_oper_log` VALUES (88, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '济南市', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-25 14:08:22\",\"flag\":false,\"params\":{},\"postCode\":\"ceo\",\"postId\":1,\"postName\":\"总经理\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:18:49', 6);
INSERT INTO `sys_oper_log` VALUES (89, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '济南市', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-25 14:08:22\",\"flag\":false,\"params\":{},\"postCode\":\"worker\",\"postId\":4,\"postName\":\"普通员工\",\"postSort\":4,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:19:10', 6);
INSERT INTO `sys_oper_log` VALUES (90, '岗位管理', 1, 'com.ruoyi.web.controller.system.SysPostController.add()', 'POST', 1, 'admin', '济南市', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"flag\":false,\"params\":{},\"postCode\":\"user\",\"postId\":5,\"postName\":\"用户\",\"postSort\":5,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:19:30', 7);
INSERT INTO `sys_oper_log` VALUES (91, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '济南市', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2024-02-25 14:08:22\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-28 22:26:24', 9);
INSERT INTO `sys_oper_log` VALUES (92, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '济南市', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-02-25 14:08:22\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,107,1035,1036,1037,1038,1061,1068,1069,1070,1071,1072,1073,1062,1063,1067],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:14:05', 22);
INSERT INTO `sys_oper_log` VALUES (93, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '济南市', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-02-25 14:08:22\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1002,107,1035,1036,1037,1038,1061,1068,1069,1070,1071,1072,1073,1062,1063,1067],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:14:47', 11);
INSERT INTO `sys_oper_log` VALUES (94, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '济南市', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-02-28 22:13:18\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,1061,1068,1069,1070,1071,1072,1073,1062,1063,1065,1066,1067],\"params\":{},\"remark\":\"工作人员\",\"roleId\":3,\"roleKey\":\"worker\",\"roleName\":\"工作人员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:15:34', 13);
INSERT INTO `sys_oper_log` VALUES (95, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 21:57:44\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1062,\"menuName\":\"通行记录\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Transactions\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:17:03', 6);
INSERT INTO `sys_oper_log` VALUES (96, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 21:59:14\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1063,\"menuName\":\"收费管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"TollRates\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:17:18', 4);
INSERT INTO `sys_oper_log` VALUES (97, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:04:03\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1066,\"menuName\":\"统计管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Datastatistics\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:17:29', 5);
INSERT INTO `sys_oper_log` VALUES (98, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:00:20\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1064,\"menuName\":\"权限管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Permissions\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:17:55', 5);
INSERT INTO `sys_oper_log` VALUES (99, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:01:12\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1065,\"menuName\":\"作弊管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"CheatingRecords\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:19:28', 4);
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2024-02-25 14:08:22\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":108,\"menuName\":\"日志管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"log\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:22:22', 4);
INSERT INTO `sys_oper_log` VALUES (101, '用户管理', 5, 'com.ruoyi.web.controller.system.SysUserController.export()', 'POST', 1, 'admin', '济南市', '/system/user/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-02-29 23:23:05', 306);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 21:57:44\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1062,\"menuName\":\"通行记录\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Transactions\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-02-29 23:23:33', 3);
INSERT INTO `sys_oper_log` VALUES (103, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1066', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 20:11:25', 8);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:04:03\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1066,\"menuName\":\"统计管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"path\":\"Datastatistics\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:11:37', 12);
INSERT INTO `sys_oper_log` VALUES (105, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1066', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 20:11:42', 5);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:04:03\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1066,\"menuName\":\"统计管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Datastatistics\",\"perms\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:11:51', 6);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1066', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 20:11:55', 0);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1066', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 20:12:05', 0);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:04:03\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1066,\"menuName\":\"统计管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Datastatistics\",\"perms\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:12:22', 3);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1066', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 20:12:28', 1);
INSERT INTO `sys_oper_log` VALUES (111, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"cp_tollbooths\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:34:11', 47);
INSERT INTO `sys_oper_log` VALUES (112, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"收费站运营状态\",\"dictType\":\"operationalstatus\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:36:18', 6);
INSERT INTO `sys_oper_log` VALUES (113, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"正常\",\"dictSort\":0,\"dictType\":\"operationalstatus\",\"dictValue\":\"0\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:37:55', 11);
INSERT INTO `sys_oper_log` VALUES (114, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"停用\",\"dictSort\":0,\"dictType\":\"operationalstatus\",\"dictValue\":\"1\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:38:21', 6);
INSERT INTO `sys_oper_log` VALUES (115, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:38:21\",\"default\":false,\"dictCode\":42,\"dictLabel\":\"停用\",\"dictSort\":0,\"dictType\":\"operationalstatus\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:38:25', 6);
INSERT INTO `sys_oper_log` VALUES (116, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:39:07', 12);
INSERT INTO `sys_oper_log` VALUES (117, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:39:07', 11);
INSERT INTO `sys_oper_log` VALUES (118, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"tollbooths\",\"className\":\"CpTollbooths\",\"columns\":[{\"capJavaField\":\"TollBoothID\",\"columnComment\":\"收费站ID\",\"columnId\":30,\"columnName\":\"TollBoothID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:34:11\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"TollBoothID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TollBoothName\",\"columnComment\":\"收费站名\",\"columnId\":31,\"columnName\":\"TollBoothName\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:34:11\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"TollBoothName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Location\",\"columnComment\":\"收费站位置，唯一\",\"columnId\":32,\"columnName\":\"Location\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:34:11\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"Location\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OperationalStatus\",\"columnComment\":\"运营状态\",\"columnId\":33,\"columnName\":\"OperationalStatus\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:34:11\",\"dictType\":\"operationalstatus\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isI', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:41:42', 12);
INSERT INTO `sys_oper_log` VALUES (119, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_tollbooths\"}', NULL, 0, NULL, '2024-03-02 20:41:48', 89);
INSERT INTO `sys_oper_log` VALUES (120, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/tollbooths/index\",\"createTime\":\"2024-03-02 20:42:19\",\"icon\":\"list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1074,\"menuName\":\"收费站管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1063,\"path\":\"tollbooths\",\"perms\":\"system:tollbooths:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 20:50:35', 13);
INSERT INTO `sys_oper_log` VALUES (121, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"cp_feedback\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 21:56:59', 35);
INSERT INTO `sys_oper_log` VALUES (122, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"feedback\",\"className\":\"CpFeedback\",\"columns\":[{\"capJavaField\":\"FeedbackID\",\"columnComment\":\"反馈信息ID\",\"columnId\":34,\"columnName\":\"FeedbackID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 21:56:59\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"FeedbackID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserID\",\"columnComment\":\"用户ID\",\"columnId\":35,\"columnName\":\"UserID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 21:56:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"UserID\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"FeedbackText\",\"columnComment\":\"反馈内容\",\"columnId\":36,\"columnName\":\"FeedbackText\",\"columnType\":\"text\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 21:56:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"FeedbackText\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Timestamp\",\"columnComment\":\"反馈时间戳\",\"columnId\":37,\"columnName\":\"Timestamp\",\"columnType\":\"timestamp\",\"createBy\":\"admin\",\"createTime\":\"2024-03-02 21:56:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 21:57:33', 24);
INSERT INTO `sys_oper_log` VALUES (123, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_feedback\"}', NULL, 0, NULL, '2024-03-02 21:57:38', 117);
INSERT INTO `sys_oper_log` VALUES (124, '反馈信息', 1, 'com.ruoyi.system.controller.CpFeedbackController.add()', 'POST', 1, 'admin', '济南市', '/system/feedback', '127.0.0.1', '内网IP', '{\"feedbackID\":1,\"params\":{},\"timestamp\":\"2024-03-02\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 22:10:30', 17);
INSERT INTO `sys_oper_log` VALUES (125, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpVehiclesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpVehiclesMapper.insertCpVehicles-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_vehicles\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1', '2024-03-02 22:13:01', 24);
INSERT INTO `sys_oper_log` VALUES (126, '收费站管理', 1, 'com.ruoyi.system.controller.CpTollboothsController.add()', 'POST', 1, 'admin', '济南市', '/system/tollbooths', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpTollboothsMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpTollboothsMapper.insertCpTollbooths-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_tollbooths\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1', '2024-03-02 22:20:04', 5);
INSERT INTO `sys_oper_log` VALUES (127, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_vehicles', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 22:34:30', 48);
INSERT INTO `sys_oper_log` VALUES (128, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-03-02 22:34:34', 125);
INSERT INTO `sys_oper_log` VALUES (129, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"CpVehicles\",\"columns\":[{\"capJavaField\":\"VehicleID\",\"columnComment\":\"车辆ID\",\"columnId\":24,\"columnName\":\"VehicleID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"1\",\"javaField\":\"VehicleID\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-02 22:34:30\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":38,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 22:34:30\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号\",\"columnId\":26,\"columnName\":\"LicensePlate\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"LicensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-02 22:34:30\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":27,\"columnName\":\"VehicleType\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:52:42\",\"dictType\":\"vehicletype\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"is', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 22:35:49', 23);
INSERT INTO `sys_oper_log` VALUES (130, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-03-02 22:35:53', 33);
INSERT INTO `sys_oper_log` VALUES (131, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1068', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 22:40:17', 3);
INSERT INTO `sys_oper_log` VALUES (132, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/vehicles/index\",\"createTime\":\"2024-02-26 22:02:29\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1068,\"menuName\":\"车辆信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1061,\"path\":\"vehicles\",\"perms\":\"system:vehicles:list\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 22:40:24', 10);
INSERT INTO `sys_oper_log` VALUES (133, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1068', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 22:40:27', 4);
INSERT INTO `sys_oper_log` VALUES (134, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1068', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 22:40:49', 4);
INSERT INTO `sys_oper_log` VALUES (135, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpVehiclesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpVehiclesMapper.insertCpVehicles-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_vehicles\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1', '2024-03-02 22:41:21', 7);
INSERT INTO `sys_oper_log` VALUES (136, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpVehiclesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpVehiclesMapper.insertCpVehicles-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_vehicles\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1', '2024-03-02 22:41:30', 2);
INSERT INTO `sys_oper_log` VALUES (137, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_vehicles', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 23:42:58', 39);
INSERT INTO `sys_oper_log` VALUES (138, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_tollbooths', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 23:43:00', 20);
INSERT INTO `sys_oper_log` VALUES (139, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_feedback', '127.0.0.1', '内网IP', '{}', NULL, 1, '同步数据失败，原表结构不存在', '2024-03-02 23:43:02', 8);
INSERT INTO `sys_oper_log` VALUES (140, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_feedback', '127.0.0.1', '内网IP', '{}', NULL, 1, '同步数据失败，原表结构不存在', '2024-03-02 23:43:07', 9);
INSERT INTO `sys_oper_log` VALUES (141, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_feedback', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-02 23:44:06', 20);
INSERT INTO `sys_oper_log` VALUES (142, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/menu/1068', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2024-03-02 23:44:30', 4);
INSERT INTO `sys_oper_log` VALUES (143, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-03-02 23:46:09', 150);
INSERT INTO `sys_oper_log` VALUES (144, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpVehiclesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpVehiclesMapper.insertCpVehicles-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_vehicles\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1', '2024-03-03 00:15:00', 48);
INSERT INTO `sys_oper_log` VALUES (145, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"licensePlate\":\" 的\",\"params\":{},\"vehicleBrand\":\"钉钉\",\"vehicleModel\":\" 的\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'LicensePlate\' in \'field list\'\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpVehiclesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpVehiclesMapper.insertCpVehicles-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_vehicles          ( LicensePlate,                          VehicleBrand,             VehicleModel )           values ( ?,                          ?,             ? )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'LicensePlate\' in \'field list\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'LicensePlate\' in \'field list\'', '2024-03-03 00:17:29', 6);
INSERT INTO `sys_oper_log` VALUES (146, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_vehicles', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 00:18:51', 29);
INSERT INTO `sys_oper_log` VALUES (147, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"CpVehicles\",\"columns\":[{\"capJavaField\":\"VehicleId\",\"columnComment\":\"车辆ID\",\"columnId\":39,\"columnName\":\"vehicle_id\",\"columnType\":\"int(11)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"vehicleId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 00:18:51\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":38,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 22:34:30\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 00:18:51\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号\",\"columnId\":40,\"columnName\":\"license_plate\",\"columnType\":\"varchar(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"licensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 00:18:51\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":41,\"columnName\":\"vehicle_type\",\"columnType\":\"varchar(50)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"ins', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 00:19:10', 23);
INSERT INTO `sys_oper_log` VALUES (148, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-03-03 00:19:13', 152);
INSERT INTO `sys_oper_log` VALUES (149, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"vehicles\",\"className\":\"CpVehicles\",\"columns\":[{\"capJavaField\":\"VehicleId\",\"columnComment\":\"车辆ID\",\"columnId\":39,\"columnName\":\"vehicle_id\",\"columnType\":\"int(11)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"vehicleId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 00:19:10\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":38,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 22:34:30\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 00:19:10\",\"usableColumn\":false},{\"capJavaField\":\"LicensePlate\",\"columnComment\":\"车牌号\",\"columnId\":40,\"columnName\":\"license_plate\",\"columnType\":\"varchar(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"licensePlate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 00:19:10\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":41,\"columnName\":\"vehicle_type\",\"columnType\":\"varchar(50)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:58\",\"dictType\":\"vehicletype\",\"edit\":true,\"htmlType\":\"select\",\"increment\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 00:25:51', 30);
INSERT INTO `sys_oper_log` VALUES (150, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_vehicles\"}', NULL, 0, NULL, '2024-03-03 00:26:02', 111);
INSERT INTO `sys_oper_log` VALUES (151, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"licensePlate\":\"123456\",\"params\":{},\"userId\":1,\"vehicleBrand\":\"是的\",\"vehicleId\":1,\"vehicleModel\":\"yexs\",\"vehicleType\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 00:27:56', 17);
INSERT INTO `sys_oper_log` VALUES (152, '车辆信息', 3, 'com.ruoyi.system.controller.CpVehiclesController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/vehicles/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 00:28:06', 5);
INSERT INTO `sys_oper_log` VALUES (153, '车辆信息', 1, 'com.ruoyi.system.controller.CpVehiclesController.add()', 'POST', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"licensePlate\":\"鲁A00001\",\"params\":{},\"userId\":1,\"vehicleBrand\":\"奥迪\",\"vehicleId\":2,\"vehicleModel\":\"A8\",\"vehicleType\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 00:28:30', 0);
INSERT INTO `sys_oper_log` VALUES (154, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/vehicles/index\",\"createTime\":\"2024-03-02 23:46:45\",\"icon\":\"车辆信息\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1092,\"menuName\":\"车辆信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1061,\"path\":\"vehicles\",\"perms\":\"system:vehicles:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:21:26', 18);
INSERT INTO `sys_oper_log` VALUES (155, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 21:55:43\",\"icon\":\"车辆管理\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"车辆管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"Vehicles\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:23:15', 1);
INSERT INTO `sys_oper_log` VALUES (156, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:01:12\",\"icon\":\"作弊管理\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1065,\"menuName\":\"作弊管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"CheatingRecords\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:24:09', 0);
INSERT INTO `sys_oper_log` VALUES (157, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"feedback\",\"className\":\"CpFeedback\",\"columns\":[{\"capJavaField\":\"FeedbackId\",\"columnComment\":\"反馈信息ID\",\"columnId\":48,\"columnName\":\"feedback_id\",\"columnType\":\"int(11)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:44:06\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"feedbackId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":49,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:44:06\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"FeedbackText\",\"columnComment\":\"反馈内容\",\"columnId\":50,\"columnName\":\"feedback_text\",\"columnType\":\"text\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:44:06\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"feedbackText\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":7,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Timestamp\",\"columnComment\":\"反馈时间\",\"columnId\":51,\"columnName\":\"timestamp\",\"columnType\":\"timestamp\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:44:06\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:25:26', 29);
INSERT INTO `sys_oper_log` VALUES (158, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_feedback\"}', NULL, 0, NULL, '2024-03-03 13:25:30', 125);
INSERT INTO `sys_oper_log` VALUES (159, '反馈信息', 1, 'com.ruoyi.system.controller.CpFeedbackController.add()', 'POST', 1, 'admin', '济南市', '/system/feedback', '127.0.0.1', '内网IP', '{\"feedbackId\":1,\"feedbackText\":\"系统内容不够丰富\",\"params\":{},\"timestamp\":\"2024-03-03\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:28:50', 18);
INSERT INTO `sys_oper_log` VALUES (160, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/feedback/index\",\"createTime\":\"2024-03-03 13:25:54\",\"icon\":\"反馈信息\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1098,\"menuName\":\"反馈信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1067,\"path\":\"feedback\",\"perms\":\"system:feedback:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:29:07', 18);
INSERT INTO `sys_oper_log` VALUES (161, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"收费站运营状态\",\"dictType\":\"cp_tollbooths\",\"params\":{},\"remark\":\"0正常运营1停止运营\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:30:48', 11);
INSERT INTO `sys_oper_log` VALUES (162, '字典类型', 3, 'com.ruoyi.web.controller.system.SysDictTypeController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/14', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:30:57', 11);
INSERT INTO `sys_oper_log` VALUES (163, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"tollbooths\",\"className\":\"CpTollbooths\",\"columns\":[{\"capJavaField\":\"TollboothId\",\"columnComment\":\"收费站ID\",\"columnId\":44,\"columnName\":\"tollbooth_id\",\"columnType\":\"int(11)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:59\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"tollboothId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TollboothName\",\"columnComment\":\"收费站名\",\"columnId\":45,\"columnName\":\"tollbooth_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"tollboothName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Location\",\"columnComment\":\"收费站位置，唯一\",\"columnId\":46,\"columnName\":\"location\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"location\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OperationalStatus\",\"columnComment\":\"运营状态\",\"columnId\":47,\"columnName\":\"operational_status\",\"columnType\":\"varchar(20)\",\"createBy\":\"\",\"createTime\":\"2024-03-02 23:42:59\",\"dictType\":\"operationalstatus\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"is', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:31:20', 24);
INSERT INTO `sys_oper_log` VALUES (164, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_tollbooths\"}', NULL, 0, NULL, '2024-03-03 13:31:45', 106);
INSERT INTO `sys_oper_log` VALUES (165, '收费站管理', 1, 'com.ruoyi.system.controller.CpTollboothsController.add()', 'POST', 1, 'admin', '济南市', '/system/tollbooths', '127.0.0.1', '内网IP', '{\"location\":\"济南西边\",\"operationalStatus\":\"0\",\"params\":{},\"tollboothId\":1,\"tollboothName\":\"济南西站\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:35:48', 31);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/tollbooths/index\",\"createTime\":\"2024-03-03 13:32:12\",\"icon\":\"收费站管理\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1104,\"menuName\":\"收费站管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1063,\"path\":\"tollbooths\",\"perms\":\"system:tollbooths:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 13:37:01', 18);
INSERT INTO `sys_oper_log` VALUES (167, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"cp_transactions\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:13:45', 37);
INSERT INTO `sys_oper_log` VALUES (168, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"支付状态\",\"dictType\":\"payment_status\",\"params\":{},\"remark\":\"0已支付1未支付\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:15:12', 11);
INSERT INTO `sys_oper_log` VALUES (169, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:36:18\",\"dictId\":13,\"dictName\":\"收费站运营状态\",\"dictType\":\"operationalstatus\",\"params\":{},\"remark\":\"0正常1停用\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:15:25', 6);
INSERT INTO `sys_oper_log` VALUES (170, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"0\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:15:45', 0);
INSERT INTO `sys_oper_log` VALUES (171, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"1\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:15:57', 6);
INSERT INTO `sys_oper_log` VALUES (172, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:16:22', 13);
INSERT INTO `sys_oper_log` VALUES (173, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"transactions\",\"className\":\"CpTransactions\",\"columns\":[{\"capJavaField\":\"TransactionId\",\"columnComment\":\"通行记录ID\",\"columnId\":52,\"columnName\":\"transaction_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:13:45\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"transactionId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"VehicleId\",\"columnComment\":\"车辆ID\",\"columnId\":53,\"columnName\":\"vehicle_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:13:45\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"vehicleId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"EntryTime\",\"columnComment\":\"车辆进入时间\",\"columnId\":54,\"columnName\":\"entry_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:13:45\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"entryTime\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ExitTime\",\"columnComment\":\"车辆离开时间\",\"columnId\":55,\"columnName\":\"exit_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:13:45\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:17:20', 12);
INSERT INTO `sys_oper_log` VALUES (174, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_transactions\"}', NULL, 0, NULL, '2024-03-03 15:17:23', 118);
INSERT INTO `sys_oper_log` VALUES (175, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/transactions/index\",\"createTime\":\"2024-03-03 15:31:49\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1110,\"menuName\":\"通行记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1062,\"path\":\"transactions\",\"perms\":\"system:transactions:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:34:46', 13);
INSERT INTO `sys_oper_log` VALUES (176, '通行记录', 1, 'com.ruoyi.system.controller.CpTransactionsController.add()', 'POST', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":110,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":235,\"tollBoothId\":1,\"transactionId\":1,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 15:35:26', 12);
INSERT INTO `sys_oper_log` VALUES (177, '通行记录', 3, 'com.ruoyi.system.controller.CpTransactionsController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/transactions/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 16:19:56', 6);
INSERT INTO `sys_oper_log` VALUES (178, '通行记录', 1, 'com.ruoyi.system.controller.CpTransactionsController.add()', 'POST', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":2,\"vehicleId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpTransactionsMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpTransactionsMapper.insertCpTransactions-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_transactions          ( vehicle_id,             entry_time,             exit_time,             distance,             toll_amount,             payment_status,             toll_booth_id )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`))', '2024-03-03 16:20:14', 35);
INSERT INTO `sys_oper_log` VALUES (179, '通行记录', 1, 'com.ruoyi.system.controller.CpTransactionsController.add()', 'POST', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":2,\"vehicleId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpTransactionsMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpTransactionsMapper.insertCpTransactions-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_transactions          ( vehicle_id,             entry_time,             exit_time,             distance,             toll_amount,             payment_status,             toll_booth_id )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_transactions`, CONSTRAINT `cp_transactions_ibfk_2` FOREIGN KEY (`toll_booth_id`) REFERENCES `cp_tollbooths` (`tollbooth_id`))', '2024-03-03 16:20:36', 0);
INSERT INTO `sys_oper_log` VALUES (180, '通行记录', 1, 'com.ruoyi.system.controller.CpTransactionsController.add()', 'POST', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 16:21:45', 4);
INSERT INTO `sys_oper_log` VALUES (181, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 16:22:04', 4);
INSERT INTO `sys_oper_log` VALUES (182, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 16:28:03', 0);
INSERT INTO `sys_oper_log` VALUES (183, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 16:56:29', 3);
INSERT INTO `sys_oper_log` VALUES (184, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03\",\"exitTime\":\"2024-03-03\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 16:58:59', 1);
INSERT INTO `sys_oper_log` VALUES (185, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-02-25 22:01:12\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1065,\"menuName\":\"作弊管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"CheatingRecords\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 19:30:44', 18);
INSERT INTO `sys_oper_log` VALUES (186, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/transactions/index\",\"createTime\":\"2024-03-03 15:31:49\",\"icon\":\"通行记录\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1110,\"menuName\":\"通行记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1062,\"path\":\"transactions\",\"perms\":\"system:transactions:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 19:31:36', 6);
INSERT INTO `sys_oper_log` VALUES (187, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03 00:00:00\",\"exitTime\":\"2024-03-03 00:00:00\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 19:40:41', 12);
INSERT INTO `sys_oper_log` VALUES (188, '通行记录', 1, 'com.ruoyi.system.controller.CpTransactionsController.add()', 'POST', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":2,\"entryTime\":\"2024-03-03 08:00:43\",\"exitTime\":\"2024-03-03 08:00:45\",\"params\":{},\"paymentStatus\":\"0\",\"tollAmount\":2,\"tollBoothId\":1,\"transactionId\":5,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 20:00:51', 23);
INSERT INTO `sys_oper_log` VALUES (189, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03 01:03:00\",\"exitTime\":\"2024-03-03 02:04:02\",\"params\":{},\"paymentStatus\":\"1\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 20:01:13', 6);
INSERT INTO `sys_oper_log` VALUES (190, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/tollbooths/index\",\"createTime\":\"2024-03-03 13:32:12\",\"icon\":\"收费站管理\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1104,\"menuName\":\"收费站信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1063,\"path\":\"tollbooths\",\"perms\":\"system:tollbooths:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 21:48:45', 18);
INSERT INTO `sys_oper_log` VALUES (191, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"作弊类型\",\"dictType\":\"cheating_type\",\"params\":{},\"remark\":\"超速：\\n\\n键值：overspeed\\n描述：车辆在高速公路上以超过规定速度行驶。\\n行为特征：车速超过路段规定的限速标准。\\n潜在影响：增加交通事故风险，危及交通安全。\\n不按规定车道行驶：\\n\\n键值：improper_lane_usage\\n描述：车辆在高速公路上未按照规定的车道行驶。\\n行为特征：车辆在超车道、应急车道或不合适的车道行驶。\\n潜在影响：引发交通拥堵和事故，影响其他车辆的通行安全。\\n虚报车辆类型：\\n\\n键值：misreport_vehicle_type\\n描述：车辆主人或驾驶员故意提供虚假的车辆类型信息。\\n行为特征：车辆主人或驾驶员错误地声称车辆的类型，以减少通行费用。\\n潜在影响：导致通行费用不准确，损害公共利益和交通管理秩序。\\n无效车牌：\\n\\n键值：invalid_license_plate\\n描述：车辆使用无效或伪造的车牌。\\n行为特征：车辆悬挂的车牌与法定要求不符或者是伪造的。\\n潜在影响：难以对车辆进行追踪和管理，增加交通管理难度和风险。\\n逃费：\\n\\n键值：toll_evasion\\n描述：车辆在收费站通过时故意逃避支付通行费用。\\n行为特征：车辆未按规定的收费方式或通行规则通过收费站。\\n潜在影响：导致通行费用损失，影响收费站的正常运营和资金收入。\\n伪造通行证：\\n\\n键值：forged_pass\\n描述：车辆主人或驾驶员使用伪造的通行证进行通行。\\n行为特征：车辆使用伪造的通行证通过收费站或者路段。\\n潜在影响：破坏通行管理秩序，损害收费管理的公平性和有效性。\",\"status\":\"0\"}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'remark\' at row 1\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-system\\target\\classes\\mapper\\system\\SysDictTypeMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysDictTypeMapper.insertDictType-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_dict_type(      dict_name,       dict_type,       status,       remark,       create_by,      create_time    )values(      ?,       ?,       ?,       ?,       ?,      sysdate()    )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'remark\' at row 1\n; Data truncation: Data too long for column \'remark\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'remark\' at row 1', '2024-03-03 22:09:43', 30);
INSERT INTO `sys_oper_log` VALUES (192, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"作弊类型\",\"dictType\":\"cheating_type\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:10:03', 0);
INSERT INTO `sys_oper_log` VALUES (193, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:10:03\",\"dictId\":16,\"dictName\":\"作弊类型\",\"dictType\":\"cheating_type\",\"params\":{},\"remark\":\"汽车高速违规类型\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:10:22', 12);
INSERT INTO `sys_oper_log` VALUES (194, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"超速\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"overspeed\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"超速：\\n\\n键值：overspeed\\n描述：车辆在高速公路上以超过规定速度行驶。\\n行为特征：车速超过路段规定的限速标准。\\n潜在影响：增加交通事故风险，危及交通安全\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:11:11', 0);
INSERT INTO `sys_oper_log` VALUES (195, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"不按规定车道行驶\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"improper_lane_usage\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"不按规定车道行驶：\\n\\n键值：improper_lane_usage\\n描述：车辆在高速公路上未按照规定的车道行驶。\\n行为特征：车辆在超车道、应急车道或不合适的车道行驶。\\n潜在影响：引发交通拥堵和事故，影响其他车辆的通行安全。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:11:49', 5);
INSERT INTO `sys_oper_log` VALUES (196, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"虚报车辆类型\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"misreport_vehicle_type\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"虚报车辆类型：\\n\\n键值：misreport_vehicle_type\\n描述：车辆主人或驾驶员故意提供虚假的车辆类型信息。\\n行为特征：车辆主人或驾驶员错误地声称车辆的类型，以减少通行费用。\\n潜在影响：导致通行费用不准确，损害公共利益和交通管理秩序。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:12:19', 5);
INSERT INTO `sys_oper_log` VALUES (197, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"无效车牌\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"invalid_license_plate\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"无效车牌：\\n\\n键值：invalid_license_plate\\n描述：车辆使用无效或伪造的车牌。\\n行为特征：车辆悬挂的车牌与法定要求不符或者是伪造的。\\n潜在影响：难以对车辆进行追踪和管理，增加交通管理难度和风险。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:12:43', 6);
INSERT INTO `sys_oper_log` VALUES (198, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"逃费\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"toll_evasion\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"逃费：\\n\\n键值：toll_evasion\\n描述：车辆在收费站通过时故意逃避支付通行费用。\\n行为特征：车辆未按规定的收费方式或通行规则通过收费站。\\n潜在影响：导致通行费用损失，影响收费站的正常运营和资金收入。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:13:04', 0);
INSERT INTO `sys_oper_log` VALUES (199, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"伪造通行证\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"forged_pass\",\"listClass\":\"default\",\"params\":{},\"remark\":\"伪造通行证：\\n\\n键值：forged_pass\\n描述：车辆主人或驾驶员使用伪造的通行证进行通行。\\n行为特征：车辆使用伪造的通行证通过收费站或者路段。\\n潜在影响：破坏通行管理秩序，损害收费管理的公平性和有效性。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:13:26', 6);
INSERT INTO `sys_oper_log` VALUES (200, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:13:26\",\"default\":false,\"dictCode\":50,\"dictLabel\":\"伪造通行证\",\"dictSort\":0,\"dictType\":\"cheating_type\",\"dictValue\":\"forged_pass\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"伪造通行证：\\n\\n键值：forged_pass\\n描述：车辆主人或驾驶员使用伪造的通行证进行通行。\\n行为特征：车辆使用伪造的通行证通过收费站或者路段。\\n潜在影响：破坏通行管理秩序，损害收费管理的公平性和有效性。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:13:32', 6);
INSERT INTO `sys_oper_log` VALUES (201, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:13:42', 11);
INSERT INTO `sys_oper_log` VALUES (202, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"处理状态\",\"dictType\":\"handling_status\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:14:02', 6);
INSERT INTO `sys_oper_log` VALUES (203, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:14:02\",\"dictId\":17,\"dictName\":\"处理状态\",\"dictType\":\"handling_status\",\"params\":{},\"remark\":\"作弊处理状态\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:14:18', 11);
INSERT INTO `sys_oper_log` VALUES (204, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未处理\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"unprocessed\",\"listClass\":\"info\",\"params\":{},\"remark\":\"未处理：\\n\\n键值：unprocessed\\n描述：作弊记录尚未被处理。\\n操作：待处理作弊记录。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:15:23', 9);
INSERT INTO `sys_oper_log` VALUES (205, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"处理中\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"processing\",\"listClass\":\"info\",\"params\":{},\"remark\":\"处理中：\\n\\n键值：processing\\n描述：作弊记录正在处理中。\\n操作：处理人员正在对作弊记录进行审核和调查。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:15:50', 0);
INSERT INTO `sys_oper_log` VALUES (206, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:15:50\",\"default\":false,\"dictCode\":52,\"dictLabel\":\"处理中\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"processing\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"处理中：\\n\\n键值：processing\\n描述：作弊记录正在处理中。\\n操作：处理人员正在对作弊记录进行审核和调查。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:16:02', 6);
INSERT INTO `sys_oper_log` VALUES (207, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已处理\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"processed\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:16:23', 5);
INSERT INTO `sys_oper_log` VALUES (208, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已撤销\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"revoked\",\"listClass\":\"warning\",\"params\":{},\"remark\":\"已撤销：\\n\\n键值：revoked\\n描述：对作弊记录的处理已经被撤销。\\n操作：之前的处理措施被撤销，作弊记录重新处于未处理状态。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:16:54', 5);
INSERT INTO `sys_oper_log` VALUES (209, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"无效\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"invalid\",\"listClass\":\"default\",\"params\":{},\"remark\":\"无效：\\n\\n键值：invalid\\n描述：作弊记录被认定为无效或不需要处理。\\n操作：作弊记录被判定为误报或其他原因无需处理。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:17:18', 6);
INSERT INTO `sys_oper_log` VALUES (210, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:17:18\",\"default\":false,\"dictCode\":55,\"dictLabel\":\"无效\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"invalid\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"无效：\\n\\n键值：invalid\\n描述：作弊记录被认定为无效或不需要处理。\\n操作：作弊记录被判定为误报或其他原因无需处理。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:17:26', 0);
INSERT INTO `sys_oper_log` VALUES (211, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:17:31', 6);
INSERT INTO `sys_oper_log` VALUES (212, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"部分支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"partial_paid\",\"listClass\":\"info\",\"params\":{},\"remark\":\"部分支付：\\n\\n键值：partial_paid\\n描述：通行费用已部分支付。\\n操作：部分通行费用已被支付，但尚有余额未支付。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:20:10', 5);
INSERT INTO `sys_oper_log` VALUES (213, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"支付超时\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"payment_timeout\",\"listClass\":\"warning\",\"params\":{},\"remark\":\"支付超时：\\n\\n键值：payment_timeout\\n描述：通行费用支付超时。\\n操作：车主或驾驶员未在规定时间内完成支付。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:20:36', 6);
INSERT INTO `sys_oper_log` VALUES (214, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:15:45\",\"default\":false,\"dictCode\":43,\"dictLabel\":\"已支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"paid\",\"isDefault\":\"N\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:20:52', 5);
INSERT INTO `sys_oper_log` VALUES (215, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:15:57\",\"default\":false,\"dictCode\":44,\"dictLabel\":\"待支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"pending\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"待支付：\\n\\n键值：pending\\n描述：通行费用尚未支付。\\n操作：车主或驾驶员需要支付通行费用。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:21:18', 5);
INSERT INTO `sys_oper_log` VALUES (216, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"支付失败\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"payment_failed\",\"listClass\":\"danger\",\"params\":{},\"remark\":\"支付失败：\\n\\n键值：payment_failed\\n描述：通行费用支付失败。\\n操作：支付操作未成功完成，可能由于支付信息错误、账户余额不足等原因导致。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:22:31', 18);
INSERT INTO `sys_oper_log` VALUES (217, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:15:57\",\"default\":false,\"dictCode\":44,\"dictLabel\":\"待支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"pending\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"待支付：\\n\\n键值：pending\\n描述：通行费用尚未支付。\\n操作：车主或驾驶员需要支付通行费用。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:22:36', 7);
INSERT INTO `sys_oper_log` VALUES (218, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:15:57\",\"default\":false,\"dictCode\":44,\"dictLabel\":\"待支付\",\"dictSort\":0,\"dictType\":\"payment_status\",\"dictValue\":\"pending\",\"isDefault\":\"N\",\"listClass\":\"primary\",\"params\":{},\"remark\":\"待支付：\\n\\n键值：pending\\n描述：通行费用尚未支付。\\n操作：车主或驾驶员需要支付通行费用。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:22:43', 6);
INSERT INTO `sys_oper_log` VALUES (219, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:22:51', 12);
INSERT INTO `sys_oper_log` VALUES (220, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":1,\"entryTime\":\"2024-03-03 01:03:00\",\"exitTime\":\"2024-03-03 02:04:02\",\"params\":{},\"paymentStatus\":\"paid\",\"tollAmount\":1,\"tollBoothId\":1,\"transactionId\":4,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:23:12', 0);
INSERT INTO `sys_oper_log` VALUES (221, '通行记录', 2, 'com.ruoyi.system.controller.CpTransactionsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/transactions', '127.0.0.1', '内网IP', '{\"distance\":2,\"entryTime\":\"2024-03-03 08:00:43\",\"exitTime\":\"2024-03-03 08:00:45\",\"params\":{},\"paymentStatus\":\"payment_failed\",\"tollAmount\":2,\"tollBoothId\":1,\"transactionId\":5,\"vehicleId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:23:16', 6);
INSERT INTO `sys_oper_log` VALUES (222, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 15:15:12\",\"dictId\":15,\"dictName\":\"支付状态\",\"dictType\":\"payment_status\",\"params\":{},\"remark\":\"支付状态\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:23:59', 18);
INSERT INTO `sys_oper_log` VALUES (223, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-02 20:36:18\",\"dictId\":13,\"dictName\":\"收费站运营状态\",\"dictType\":\"operationalstatus\",\"params\":{},\"remark\":\"收费站运营状态\\n\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:24:14', 12);
INSERT INTO `sys_oper_log` VALUES (224, '字典类型', 3, 'com.ruoyi.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/dict/data/56', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:30:11', 8);
INSERT INTO `sys_oper_log` VALUES (225, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"cp_cheatingrecords\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:31:35', 35);
INSERT INTO `sys_oper_log` VALUES (226, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:16:23\",\"default\":false,\"dictCode\":53,\"dictLabel\":\"已处理\",\"dictSort\":0,\"dictType\":\"handling_status\",\"dictValue\":\"processed\",\"isDefault\":\"N\",\"listClass\":\"primary\",\"params\":{},\"remark\":\"已处理：\\n\\n键值：processed\\n描述：作弊记录已经被处理。\\n操作：对作弊行为进行了处理，例如罚款、警告或其他处罚措施。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:33:21', 5);
INSERT INTO `sys_oper_log` VALUES (227, '字典类型', 3, 'com.ruoyi.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/dict/data/54', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:33:47', 7);
INSERT INTO `sys_oper_log` VALUES (228, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:33:57', 12);
INSERT INTO `sys_oper_log` VALUES (229, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"cheatingrecords\",\"className\":\"CpCheatingrecords\",\"columns\":[{\"capJavaField\":\"RecordId\",\"columnComment\":\"作弊记录ID\",\"columnId\":60,\"columnName\":\"record_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:31:35\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"recordId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TransactionId\",\"columnComment\":\"通行记录ID\",\"columnId\":61,\"columnName\":\"transaction_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:31:35\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"transactionId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CheatingType\",\"columnComment\":\"作弊类型\",\"columnId\":62,\"columnName\":\"cheating_type\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:31:35\",\"dictType\":\"cheating_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"cheatingType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"DetectionTime\",\"columnComment\":\"作弊检测时间\",\"columnId\":63,\"columnName\":\"detection_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 22:31:35\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncr', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:34:31', 12);
INSERT INTO `sys_oper_log` VALUES (230, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_cheatingrecords\"}', NULL, 0, NULL, '2024-03-03 22:34:37', 118);
INSERT INTO `sys_oper_log` VALUES (231, '作弊记录', 1, 'com.ruoyi.system.controller.CpCheatingrecordsController.add()', 'POST', 1, 'admin', '济南市', '/system/cheatingrecords', '127.0.0.1', '内网IP', '{\"cheatingType\":\"overspeed\",\"detectionTime\":\"2024-03-03\",\"handlingDetails\":\"超速行驶\\n\",\"handlingStatus\":\"processing\",\"params\":{},\"transactionId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpCheatingrecordsMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpCheatingrecordsMapper.insertCpCheatingrecords-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_cheatingrecords          ( transaction_id,             cheating_type,             detection_time,             handling_status,             handling_details )           values ( ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))', '2024-03-03 22:46:26', 47);
INSERT INTO `sys_oper_log` VALUES (232, '作弊记录', 1, 'com.ruoyi.system.controller.CpCheatingrecordsController.add()', 'POST', 1, 'admin', '济南市', '/system/cheatingrecords', '127.0.0.1', '内网IP', '{\"cheatingType\":\"overspeed\",\"detectionTime\":\"2024-03-03\",\"handlingDetails\":\"超速行驶\\n\",\"handlingStatus\":\"processing\",\"params\":{},\"transactionId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpCheatingrecordsMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpCheatingrecordsMapper.insertCpCheatingrecords-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_cheatingrecords          ( transaction_id,             cheating_type,             detection_time,             handling_status,             handling_details )           values ( ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))', '2024-03-03 22:48:39', 5);
INSERT INTO `sys_oper_log` VALUES (233, '作弊记录', 1, 'com.ruoyi.system.controller.CpCheatingrecordsController.add()', 'POST', 1, 'admin', '济南市', '/system/cheatingrecords', '127.0.0.1', '内网IP', '{\"cheatingType\":\"overspeed\",\"detectionTime\":\"2024-03-03\",\"handlingDetails\":\"超速行驶\\n\",\"handlingStatus\":\"processing\",\"params\":{},\"recordId\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:50:43', 6);
INSERT INTO `sys_oper_log` VALUES (234, '作弊记录', 2, 'com.ruoyi.system.controller.CpCheatingrecordsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/cheatingrecords', '127.0.0.1', '内网IP', '{\"cheatingType\":\"overspeed\",\"detectionTime\":\"2024-03-03\",\"handlingDetails\":\"超速行驶\\n\",\"handlingStatus\":\"processing\",\"params\":{},\"recordId\":3,\"transactionId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpCheatingrecordsMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpCheatingrecordsMapper.updateCpCheatingrecords-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update cp_cheatingrecords          SET transaction_id = ?,             cheating_type = ?,             detection_time = ?,             handling_status = ?,             handling_details = ?          where record_id = ?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_cheatingrecords`, CONSTRAINT `cp_cheatingrecords_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `cp_transactions` (`transaction_id`))', '2024-03-03 22:50:59', 5);
INSERT INTO `sys_oper_log` VALUES (235, '作弊记录', 2, 'com.ruoyi.system.controller.CpCheatingrecordsController.edit()', 'PUT', 1, 'admin', '济南市', '/system/cheatingrecords', '127.0.0.1', '内网IP', '{\"cheatingType\":\"overspeed\",\"detectionTime\":\"2024-03-03\",\"handlingDetails\":\"超速行驶\\n\",\"handlingStatus\":\"processing\",\"params\":{},\"recordId\":3,\"transactionId\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 22:58:38', 2);
INSERT INTO `sys_oper_log` VALUES (236, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '济南市', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/cheatingrecords/index\",\"createTime\":\"2024-03-03 22:35:04\",\"icon\":\"作弊记录\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1116,\"menuName\":\"作弊记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1065,\"path\":\"cheatingrecords\",\"perms\":\"system:cheatingrecords:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:01:33', 36);
INSERT INTO `sys_oper_log` VALUES (237, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:20:20\",\"default\":false,\"dictCode\":33,\"dictLabel\":\"轿车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"sedan\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"通常是指乘用车，包括轿车、掀背车、两厢车等小型乘用车型。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:24:11', 5);
INSERT INTO `sys_oper_log` VALUES (238, '字典类型', 3, 'com.ruoyi.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/dict/data/34', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:24:18', 6);
INSERT INTO `sys_oper_log` VALUES (239, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:21:08\",\"default\":false,\"dictCode\":35,\"dictLabel\":\"大型客车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"large_bus\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"用于运输乘客的大型客车，如长途客车、旅游巴士等。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:24:42', 6);
INSERT INTO `sys_oper_log` VALUES (240, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:21:30\",\"default\":false,\"dictCode\":36,\"dictLabel\":\"货车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"truck\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"用于货物运输的大型车辆，包括轻型、中型和重型卡车，以及载重卡车、自卸卡车等类型。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:24:55', 6);
INSERT INTO `sys_oper_log` VALUES (241, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:21:49\",\"default\":false,\"dictCode\":37,\"dictLabel\":\"摩托车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"motorcycle\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"两轮或三轮摩托车，通常用于个人代步或快递配送。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:25:14', 6);
INSERT INTO `sys_oper_log` VALUES (242, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:22:08\",\"default\":false,\"dictCode\":38,\"dictLabel\":\"大型货车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"large_truck\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"由载货车辆牵引的附属车辆，用于额外的货物运输或车辆运输。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:25:40', 6);
INSERT INTO `sys_oper_log` VALUES (243, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:22:36\",\"default\":false,\"dictCode\":39,\"dictLabel\":\"特种车辆\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"special_vehicle\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"特定用途的车辆，如消防车、救护车、工程车等，通常具有特殊的行驶和停靠要求。\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:25:55', 88);
INSERT INTO `sys_oper_log` VALUES (244, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-02-26 21:30:15\",\"default\":false,\"dictCode\":40,\"dictLabel\":\"中小型客车\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"medium-sized_bus\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:27:54', 6);
INSERT INTO `sys_oper_log` VALUES (245, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '济南市', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"小型车辆\",\"dictSort\":0,\"dictType\":\"vehicletype\",\"dictValue\":\"compact_car\",\"listClass\":\"default\",\"params\":{},\"remark\":\"描述：车身尺寸较小的小型汽车，适合在城市间通行和停车，通常收取普通车辆费率。\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:28:42', 5);
INSERT INTO `sys_oper_log` VALUES (246, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '济南市', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:28:47', 10);
INSERT INTO `sys_oper_log` VALUES (247, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '济南市', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"cp_tollrates\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:34:12', 29);
INSERT INTO `sys_oper_log` VALUES (248, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"tollrates\",\"className\":\"CpTollrates\",\"columns\":[{\"capJavaField\":\"RateId\",\"columnComment\":\"费率ID\",\"columnId\":66,\"columnName\":\"rate_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"rateId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"VehicleId\",\"columnComment\":\"车辆ID\",\"columnId\":67,\"columnName\":\"vehicle_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"vehicleId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TollboothId\",\"columnComment\":\"收费站ID\",\"columnId\":68,\"columnName\":\"tollbooth_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"tollboothId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BaseFee\",\"columnComment\":\"车次基础费用\",\"columnId\":69,\"columnName\":\"base_fee\",\"columnType\":\"decimal(8,2)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"i', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:34:43', 24);
INSERT INTO `sys_oper_log` VALUES (249, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"tollrates\",\"className\":\"CpTollrates\",\"columns\":[{\"capJavaField\":\"RateId\",\"columnComment\":\"费率ID\",\"columnId\":66,\"columnName\":\"rate_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"rateId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 23:34:43\",\"usableColumn\":false},{\"capJavaField\":\"VehicleId\",\"columnComment\":\"车辆ID\",\"columnId\":67,\"columnName\":\"vehicle_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"vehicleId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 23:34:43\",\"usableColumn\":false},{\"capJavaField\":\"TollboothId\",\"columnComment\":\"收费站ID\",\"columnId\":68,\"columnName\":\"tollbooth_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"tollboothId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 23:34:43\",\"usableColumn\":false},{\"capJavaField\":\"BaseFee\",\"columnComment\":\"车次基础费用\",\"columnId\":69,\"columnName\":\"base_fee\",\"columnType\":\"decimal(8,2)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":f', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:34:56', 11);
INSERT INTO `sys_oper_log` VALUES (250, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_tollrates\"}', NULL, 0, NULL, '2024-03-03 23:35:01', 63);
INSERT INTO `sys_oper_log` VALUES (251, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '济南市', '/tool/gen/synchDb/cp_tollrates', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:44:16', 48);
INSERT INTO `sys_oper_log` VALUES (252, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '济南市', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"tollrates\",\"className\":\"CpTollrates\",\"columns\":[{\"capJavaField\":\"RateId\",\"columnComment\":\"费率ID\",\"columnId\":66,\"columnName\":\"rate_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"rateId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 23:44:16\",\"usableColumn\":false},{\"capJavaField\":\"VehicleType\",\"columnComment\":\"车辆类型\",\"columnId\":73,\"columnName\":\"vehicle_type\",\"columnType\":\"varchar(50)\",\"createBy\":\"\",\"createTime\":\"2024-03-03 23:44:16\",\"dictType\":\"vehicletype\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"vehicleType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TollboothId\",\"columnComment\":\"收费站ID\",\"columnId\":68,\"columnName\":\"tollbooth_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"tollboothId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2024-03-03 23:44:16\",\"usableColumn\":false},{\"capJavaField\":\"BaseFee\",\"columnComment\":\"车次基础费用\",\"columnId\":69,\"columnName\":\"base_fee\",\"columnType\":\"decimal(8,2)\",\"createBy\":\"admin\",\"createTime\":\"2024-03-03 23:34:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":tr', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:44:24', 17);
INSERT INTO `sys_oper_log` VALUES (253, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '济南市', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"cp_tollrates\"}', NULL, 0, NULL, '2024-03-03 23:45:06', 123);
INSERT INTO `sys_oper_log` VALUES (254, '收费标准', 1, 'com.ruoyi.system.controller.CpTollratesController.add()', 'POST', 1, 'admin', '济南市', '/system/tollrates', '127.0.0.1', '内网IP', '{\"params\":{},\"tollboothId\":1,\"validFrom\":\"2024-03-03\",\"validTo\":\"2024-03-03\",\"vehicleType\":\"sedan\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpTollratesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpTollratesMapper.insertCpTollrates-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_tollrates          ( vehicle_type,             tollbooth_id,                                       valid_from,             valid_to )           values ( ?,             ?,                                       ?,             ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`))', '2024-03-03 23:47:51', 53);
INSERT INTO `sys_oper_log` VALUES (255, '收费标准', 1, 'com.ruoyi.system.controller.CpTollratesController.add()', 'POST', 1, 'admin', '济南市', '/system/tollrates', '127.0.0.1', '内网IP', '{\"baseFee\":2,\"params\":{},\"perKilometerFee\":8,\"tollboothId\":1,\"validFrom\":\"2024-03-03\",\"validTo\":\"2024-03-03\",\"vehicleType\":\"sedan\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`))\r\n### The error may exist in file [F:\\CloudPaylink\\ruoyi-admin\\target\\classes\\mapper\\system\\CpTollratesMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CpTollratesMapper.insertCpTollrates-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cp_tollrates          ( vehicle_type,             tollbooth_id,             base_fee,             per_kilometer_fee,             valid_from,             valid_to )           values ( ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`))\n; Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`)); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot add or update a child row: a foreign key constraint fails (`cloudpayment`.`cp_tollrates`, CONSTRAINT `cp_tollrates_ibfk_1` FOREIGN KEY (`vehicle_type`) REFERENCES `cp_vehicles` (`vehicle_type`))', '2024-03-03 23:48:02', 7);
INSERT INTO `sys_oper_log` VALUES (256, '车辆信息', 2, 'com.ruoyi.system.controller.CpVehiclesController.edit()', 'PUT', 1, 'admin', '济南市', '/system/vehicles', '127.0.0.1', '内网IP', '{\"licensePlate\":\"鲁A00001\",\"params\":{},\"userId\":1,\"vehicleBrand\":\"奥迪\",\"vehicleId\":1,\"vehicleModel\":\"A8\",\"vehicleType\":\"sedan\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:49:24', 6);
INSERT INTO `sys_oper_log` VALUES (257, '收费标准', 1, 'com.ruoyi.system.controller.CpTollratesController.add()', 'POST', 1, 'admin', '济南市', '/system/tollrates', '127.0.0.1', '内网IP', '{\"baseFee\":2,\"params\":{},\"perKilometerFee\":8,\"rateId\":3,\"tollboothId\":1,\"validFrom\":\"2024-03-03\",\"validTo\":\"2024-03-03\",\"vehicleType\":\"sedan\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:49:49', 3);
INSERT INTO `sys_oper_log` VALUES (258, '收费标准', 1, 'com.ruoyi.system.controller.CpTollratesController.add()', 'POST', 1, 'admin', '济南市', '/system/tollrates', '127.0.0.1', '内网IP', '{\"params\":{},\"rateId\":4,\"tollboothId\":1,\"validFrom\":\"2024-03-04\",\"validTo\":\"2024-03-15\",\"vehicleType\":\"sedan\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:50:04', 3);
INSERT INTO `sys_oper_log` VALUES (259, '收费标准', 2, 'com.ruoyi.system.controller.CpTollratesController.edit()', 'PUT', 1, 'admin', '济南市', '/system/tollrates', '127.0.0.1', '内网IP', '{\"params\":{},\"rateId\":4,\"tollboothId\":1,\"validFrom\":\"2024-03-04\",\"validTo\":\"2024-03-15\",\"vehicleType\":\"sedan\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:51:01', 0);
INSERT INTO `sys_oper_log` VALUES (260, '收费标准', 3, 'com.ruoyi.system.controller.CpTollratesController.remove()', 'DELETE', 1, 'admin', '济南市', '/system/tollrates/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:51:14', 4);
INSERT INTO `sys_oper_log` VALUES (261, '收费标准', 1, 'com.ruoyi.system.controller.CpTollratesController.add()', 'POST', 1, 'admin', '济南市', '/system/tollrates', '127.0.0.1', '内网IP', '{\"params\":{},\"rateId\":5,\"tollboothId\":1,\"validFrom\":\"2024-02-28\",\"validTo\":\"2024-02-29\",\"vehicleType\":\"sedan\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-03-03 23:51:24', 0);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '总经理', 1, '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-28 22:18:49', '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2024-02-25 14:08:22', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'worker', '普通员工', 4, '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-28 22:19:10', '');
INSERT INTO `sys_post` VALUES (5, 'user', '用户', 5, '0', 'admin', '2024-02-28 22:19:30', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-02-25 14:08:22', '', NULL, '管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-02-25 14:08:22', 'admin', '2024-02-29 23:14:47', '普通角色');
INSERT INTO `sys_role` VALUES (3, '工作人员', 'worker', 3, '2', 1, 1, '0', '0', 'admin', '2024-02-28 22:13:18', 'admin', '2024-02-29 23:15:34', '工作人员');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1061);
INSERT INTO `sys_role_menu` VALUES (2, 1062);
INSERT INTO `sys_role_menu` VALUES (2, 1063);
INSERT INTO `sys_role_menu` VALUES (2, 1067);
INSERT INTO `sys_role_menu` VALUES (2, 1068);
INSERT INTO `sys_role_menu` VALUES (2, 1069);
INSERT INTO `sys_role_menu` VALUES (2, 1070);
INSERT INTO `sys_role_menu` VALUES (2, 1071);
INSERT INTO `sys_role_menu` VALUES (2, 1072);
INSERT INTO `sys_role_menu` VALUES (2, 1073);
INSERT INTO `sys_role_menu` VALUES (3, 1);
INSERT INTO `sys_role_menu` VALUES (3, 100);
INSERT INTO `sys_role_menu` VALUES (3, 103);
INSERT INTO `sys_role_menu` VALUES (3, 104);
INSERT INTO `sys_role_menu` VALUES (3, 1000);
INSERT INTO `sys_role_menu` VALUES (3, 1001);
INSERT INTO `sys_role_menu` VALUES (3, 1002);
INSERT INTO `sys_role_menu` VALUES (3, 1003);
INSERT INTO `sys_role_menu` VALUES (3, 1004);
INSERT INTO `sys_role_menu` VALUES (3, 1005);
INSERT INTO `sys_role_menu` VALUES (3, 1006);
INSERT INTO `sys_role_menu` VALUES (3, 1016);
INSERT INTO `sys_role_menu` VALUES (3, 1017);
INSERT INTO `sys_role_menu` VALUES (3, 1018);
INSERT INTO `sys_role_menu` VALUES (3, 1019);
INSERT INTO `sys_role_menu` VALUES (3, 1020);
INSERT INTO `sys_role_menu` VALUES (3, 1021);
INSERT INTO `sys_role_menu` VALUES (3, 1022);
INSERT INTO `sys_role_menu` VALUES (3, 1023);
INSERT INTO `sys_role_menu` VALUES (3, 1024);
INSERT INTO `sys_role_menu` VALUES (3, 1061);
INSERT INTO `sys_role_menu` VALUES (3, 1062);
INSERT INTO `sys_role_menu` VALUES (3, 1063);
INSERT INTO `sys_role_menu` VALUES (3, 1065);
INSERT INTO `sys_role_menu` VALUES (3, 1066);
INSERT INTO `sys_role_menu` VALUES (3, 1067);
INSERT INTO `sys_role_menu` VALUES (3, 1068);
INSERT INTO `sys_role_menu` VALUES (3, 1069);
INSERT INTO `sys_role_menu` VALUES (3, 1070);
INSERT INTO `sys_role_menu` VALUES (3, 1071);
INSERT INTO `sys_role_menu` VALUES (3, 1072);
INSERT INTO `sys_role_menu` VALUES (3, 1073);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '管理员', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-03-03 21:47:50', 'admin', '2024-02-25 14:08:22', '', '2024-03-03 21:47:50', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'user', '普通用户', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-02-25 14:08:22', 'admin', '2024-02-25 14:08:22', '', NULL, '普通用户');
INSERT INTO `sys_user` VALUES (3, 106, 'worker', '工作人员', '00', 'ry@123.com', '15777777777', '0', '', '$2a$10$0oIl37.i1PuIQUEr0EIVK.8DvQp6IJZD4W4/2aqiDrYRrDFpC0rwS', '0', '0', '127.0.0.1', '2024-02-28 22:16:29', 'admin', '2024-02-28 22:15:26', 'admin', '2024-02-28 22:17:26', '工作人员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);
INSERT INTO `sys_user_post` VALUES (3, 4);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (3, 3);

SET FOREIGN_KEY_CHECKS = 1;
