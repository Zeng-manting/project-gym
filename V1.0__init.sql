-- 文件：V1.0__init.sql  
CREATE DATABASE IF NOT EXISTS gym DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;   
USE gym;   

-- 1. 卡类型字典表
CREATE TABLE card_type (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    type_name VARCHAR(120) NOT NULL COMMENT '卡类型名称(年卡/次卡)',
    type_code VARCHAR(60) NOT NULL UNIQUE COMMENT '卡类型编码',
    days_valid INT NOT NULL COMMENT '有效期天数',
    times_valid INT DEFAULT 0 COMMENT '有效次数(次卡专用)',
    price_amount BIGINT NOT NULL COMMENT '价格(分)',
    description VARCHAR(500) COMMENT '描述',
    sort_order INT DEFAULT 0 COMMENT '排序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除(0正常1删除)',
    
    INDEX idx_type_code (type_code),
    INDEX idx_deleted_sort (deleted, sort_order)
) ENGINE=InnoDB COMMENT='卡类型字典表';

-- 2. 字典表
CREATE TABLE sys_dict (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    dict_type VARCHAR(60) NOT NULL COMMENT '字典类型',
    dict_code VARCHAR(60) NOT NULL COMMENT '字典编码',
    dict_name VARCHAR(120) NOT NULL COMMENT '字典名称',
    dict_value VARCHAR(120) COMMENT '字典值',
    sort_order INT DEFAULT 0 COMMENT '排序',
    description VARCHAR(500) COMMENT '描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    UNIQUE KEY uk_type_code (dict_type, dict_code, deleted),
    INDEX idx_dict_type (dict_type, deleted)
) ENGINE=InnoDB COMMENT='系统字典表';

-- 3. 管理员表
CREATE TABLE admin (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    username VARCHAR(120) NOT NULL UNIQUE COMMENT '登录名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(120) COMMENT '真实姓名',
    email VARCHAR(120) UNIQUE COMMENT '邮箱',
    phone VARCHAR(120) UNIQUE COMMENT '手机号',
    status SMALLINT DEFAULT 1 COMMENT '状态(1正常2禁用)',
    last_login_time DATETIME COMMENT '最后登录时间',
    login_count INT DEFAULT 0 COMMENT '登录次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_status_deleted (status, deleted)
) ENGINE=InnoDB COMMENT='管理员表';

-- 4. 教练表
CREATE TABLE coach (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    username VARCHAR(120) NOT NULL UNIQUE COMMENT '登录名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(120) NOT NULL COMMENT '真实姓名',
    email VARCHAR(120) UNIQUE COMMENT '邮箱',
    phone VARCHAR(120) UNIQUE COMMENT '手机号',
    avatar_url VARCHAR(500) COMMENT '头像URL',
    specialty VARCHAR(500) COMMENT '专长',
    experience_years INT DEFAULT 0 COMMENT '从业年数',
    certificate_no VARCHAR(120) COMMENT '证书编号',
    intro TEXT COMMENT '个人简介',
    status SMALLINT DEFAULT 1 COMMENT '状态(1正常2禁用)',
    last_login_time DATETIME COMMENT '最后登录时间',
    login_count INT DEFAULT 0 COMMENT '登录次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_status_deleted (status, deleted)
) ENGINE=InnoDB COMMENT='教练表';

-- 5. 会员表
CREATE TABLE member (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    username VARCHAR(120) NOT NULL UNIQUE COMMENT '登录名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(120) NOT NULL COMMENT '真实姓名',
    email VARCHAR(120) UNIQUE COMMENT '邮箱',
    phone VARCHAR(120) UNIQUE COMMENT '手机号',
    card_no VARCHAR(120) UNIQUE COMMENT '会员卡号',
    balance_amount BIGINT DEFAULT 0 COMMENT '余额(分)',
    card_type_id BIGINT NOT NULL COMMENT '卡类型ID',
    card_start_date DATE COMMENT '开卡日期',
    card_end_date DATE COMMENT '到期日期',
    card_times INT DEFAULT 0 COMMENT '剩余次数(次卡)',
    status SMALLINT DEFAULT 1 COMMENT '状态(1正常2冻结3过期)',
    last_login_time DATETIME COMMENT '最后登录时间',
    login_count INT DEFAULT 0 COMMENT '登录次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_card_no (card_no),
    INDEX idx_card_type (card_type_id),
    INDEX idx_status_enddate (status, card_end_date),
    INDEX idx_deleted_status (deleted, status)
) ENGINE=InnoDB COMMENT='会员表';

-- 6. 课程表
CREATE TABLE course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    course_name VARCHAR(120) NOT NULL COMMENT '课程名称',
    course_code VARCHAR(60) NOT NULL UNIQUE COMMENT '课程编码',
    coach_id BIGINT NOT NULL COMMENT '教练ID',
    course_date DATE NOT NULL COMMENT '上课日期',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    max_persons INT NOT NULL COMMENT '最大人数',
    current_persons INT DEFAULT 0 COMMENT '已报人数',
    price_amount BIGINT NOT NULL COMMENT '价格(分)',
    description TEXT COMMENT '课程描述',
    status SMALLINT DEFAULT 1 COMMENT '状态(1可报名2已满3已结束4已取消)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_coach_id (coach_id),
    INDEX idx_course_date (course_date),
    INDEX idx_status_date (status, course_date),
    INDEX idx_current_max (current_persons, max_persons),
    INDEX idx_deleted_status (deleted, status)
) ENGINE=InnoDB COMMENT='课程表';

-- 7. 课程报名表
CREATE TABLE course_enroll (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    member_id BIGINT NOT NULL COMMENT '会员ID',
    course_id BIGINT NOT NULL COMMENT '课程ID',
    enroll_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
    status SMALLINT DEFAULT 1 COMMENT '状态(1已报名2已签到3已完成4已取消)',
    check_in_time DATETIME COMMENT '签到时间',
    cancel_time DATETIME COMMENT '取消时间',
    refund_amount BIGINT DEFAULT 0 COMMENT '退款金额(分)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    UNIQUE KEY uk_member_course (member_id, course_id, deleted),
    INDEX idx_member_id (member_id),
    INDEX idx_course_id (course_id),
    INDEX idx_status (status),
    INDEX idx_enroll_time (enroll_time),
    INDEX idx_deleted_status (deleted, status)
) ENGINE=InnoDB COMMENT='课程报名表';

-- 8. 充值记录表
CREATE TABLE recharge (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    member_id BIGINT NOT NULL COMMENT '会员ID',
    recharge_amount BIGINT NOT NULL COMMENT '充值金额(分)',
    pay_method SMALLINT NOT NULL COMMENT '支付方式(1微信2支付宝3银行卡)',
    pay_time DATETIME COMMENT '支付时间',
    pay_status SMALLINT DEFAULT 1 COMMENT '支付状态(1待支付2已支付3已退款)',
    transaction_no VARCHAR(120) COMMENT '第三方交易号',
    admin_id BIGINT COMMENT '审核管理员ID',
    audit_time DATETIME COMMENT '审核时间',
    audit_remark VARCHAR(500) COMMENT '审核备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_member_id (member_id),
    INDEX idx_pay_status (pay_status),
    INDEX idx_transaction_no (transaction_no),
    INDEX idx_admin_id (admin_id),
    INDEX idx_create_time (create_time),
    INDEX idx_deleted_status (deleted, pay_status)
) ENGINE=InnoDB COMMENT='充值记录表';

-- 9. 公告表
CREATE TABLE announcement (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    priority SMALLINT DEFAULT 1 COMMENT '优先级(1普通2重要3紧急)',
    publish_time DATETIME COMMENT '发布时间',
    expire_time DATETIME COMMENT '过期时间',
    publisher_id BIGINT NOT NULL COMMENT '发布人ID',
    publisher_type SMALLINT NOT NULL COMMENT '发布人类型(1管理员2教练)',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    status SMALLINT DEFAULT 1 COMMENT '状态(1草稿2已发布3已下线)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_priority (priority),
    INDEX idx_publish_time (publish_time),
    INDEX idx_status_time (status, publish_time, expire_time),
    INDEX idx_publisher (publisher_id, publisher_type),
    INDEX idx_deleted_status (deleted, status)
) ENGINE=InnoDB COMMENT='公告表';

-- 10. 续卡记录表
CREATE TABLE card_renewal (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    member_id BIGINT NOT NULL COMMENT '会员ID',
    old_card_type_id BIGINT NOT NULL COMMENT '原卡类型ID',
    new_card_type_id BIGINT NOT NULL COMMENT '新卡类型ID',
    renewal_amount BIGINT NOT NULL COMMENT '续卡金额(分)',
    old_end_date DATE NOT NULL COMMENT '原到期日期',
    new_end_date DATE NOT NULL COMMENT '新到期日期',
    admin_id BIGINT NOT NULL COMMENT '操作管理员ID',
    remark VARCHAR(500) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT(1) DEFAULT 0 COMMENT '逻辑删除',
    
    INDEX idx_member_id (member_id),
    INDEX idx_admin_id (admin_id),
    INDEX idx_create_time (create_time),
    INDEX idx_deleted_member (deleted, member_id)
) ENGINE=InnoDB COMMENT='续卡记录表';

-- 初始化字典数据
INSERT INTO sys_dict (dict_type, dict_code, dict_name, dict_value, sort_order, description) VALUES
('user_status', 'active', '正常', '1', 1, '用户正常状态'),
('user_status', 'disabled', '禁用', '2', 2, '用户禁用状态'),
('pay_method', 'wechat', '微信支付', '1', 1, '微信支付方式'),
('pay_method', 'alipay', '支付宝', '2', 2, '支付宝支付方式'),
('pay_method', 'bank', '银行卡', '3', 3, '银行卡支付方式'),
('pay_status', 'pending', '待支付', '1', 1, '待支付状态'),
('pay_status', 'paid', '已支付', '2', 2, '已支付状态'),
('pay_status', 'refunded', '已退款', '3', 3, '已退款状态'),
('course_status', 'open', '可报名', '1', 1, '课程可报名状态'),
('course_status', 'full', '已满', '2', 2, '课程已满状态'),
('course_status', 'ended', '已结束', '3', 3, '课程已结束状态'),
('course_status', 'cancelled', '已取消', '4', 4, '课程已取消状态'),
('enroll_status', 'enrolled', '已报名', '1', 1, '已报名状态'),
('enroll_status', 'checked', '已签到', '2', 2, '已签到状态'),
('enroll_status', 'completed', '已完成', '3', 3, '已完成状态'),
('enroll_status', 'cancelled', '已取消', '4', 4, '已取消状态'),
('announcement_priority', 'normal', '普通', '1', 1, '普通优先级'),
('announcement_priority', 'important', '重要', '2', 2, '重要优先级'),
('announcement_priority', 'urgent', '紧急', '3', 3, '紧急优先级');

-- 初始化管理员数据（密码：admin123）
INSERT INTO admin (username, password, real_name, email, phone, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8i4kJ3b8y5nJjKkU0j6gF4zZkLdW', '系统管理员', 'admin@gym.com', '13800138000', 1);

-- 初始化卡类型数据
INSERT INTO card_type (type_name, type_code, days_valid, times_valid, price_amount, description, sort_order) VALUES
('年卡', 'YEAR_CARD', 365, 0, 3650000, '一年有效期，无限次数', 1),
('季卡', 'QUARTER_CARD', 90, 0, 900000, '三个月有效期，无限次数', 2),
('月卡', 'MONTH_CARD', 30, 0, 300000, '一个月有效期，无限次数', 3),
('次卡20次', 'TIMES_CARD_20', 180, 20, 200000, '六个月有效期，20次次数', 4),
('次卡50次', 'TIMES_CARD_50', 365, 50, 450000, '一年有效期，50次次数', 5);
