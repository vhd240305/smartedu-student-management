create database quanlysinhvien

use quanlysinhvien
CREATE TABLE account (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL
);

CREATE TABLE teacher (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    department VARCHAR(100),
    account_id INT UNIQUE,
    CONSTRAINT fk_teacher_account FOREIGN KEY (account_id) REFERENCES account(id)
);

CREATE TABLE student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    gender VARCHAR(10),
    dob DATE,
    address VARCHAR(255),
    avatar VARCHAR(255),
    account_id INT UNIQUE,
    CONSTRAINT fk_student_account FOREIGN KEY (account_id) REFERENCES account(id)
);

CREATE TABLE classroom (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    room VARCHAR(50),
    description TEXT,
    teacher_id INT,
    CONSTRAINT fk_classroom_teacher FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

CREATE TABLE student_classroom (
    student_id INT,
    classroom_id INT,
    PRIMARY KEY (student_id, classroom_id),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (classroom_id) REFERENCES classroom(id)
);

CREATE TABLE password_reset (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(120) NOT NULL,
    otp VARCHAR(6) NOT NULL,
    expires_at DATETIME NOT NULL,
    used TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE score (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    classroom_id INT NOT NULL,
    midterm_score FLOAT DEFAULT NULL,
    final_score FLOAT DEFAULT NULL,
    gpa FLOAT DEFAULT NULL,
    semester VARCHAR(20),
    academic_year VARCHAR(20),
    status VARCHAR(20) DEFAULT 'draft',
    -- draft = giảng viên chưa nộp
    -- pending = giảng viên đã nộp, chờ admin duyệt
    -- approved = admin đã duyệt
    -- rejected = admin từ chối
    note TEXT,
    -- ghi chú khi admin từ chối
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (classroom_id) REFERENCES classroom(id) ON DELETE CASCADE,
    UNIQUE KEY unique_score (student_id, classroom_id)
);

CREATE TABLE score_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    score_id INT NOT NULL,
    student_id INT NOT NULL,
    classroom_id INT NOT NULL,
    field_changed VARCHAR(50) NOT NULL,
    old_value VARCHAR(20),
    new_value VARCHAR(20),
    changed_by INT NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    FOREIGN KEY (score_id) REFERENCES score(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES account(id)
);
select * from account

select * from student

select * from classroom

select * from teacher

select * from password_reset

select * from score

select * from score_history

select * from student_classroom

INSERT INTO account (id, username, password, role)
VALUES (1, "admin", "123456", "admin");

SELECT NOW();
