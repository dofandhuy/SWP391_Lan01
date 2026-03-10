-- =========================
-- Tạo Database
-- =========================
CREATE DATABASE LMS_1;
GO

USE LMS_1;
GO

-- =========================
-- Bảng Roles
-- =========================
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE -- Admin, Instructor, Student, Parent
);

-- =========================
-- Bảng Users
-- =========================
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    FullName NVARCHAR(150),
    Avatar NVARCHAR(255), -- thêm avatar để hiển thị profile
    Phone NVARCHAR(20),
    Sex NVARCHAR(10),
    Address NVARCHAR(255),
    DOB DATE;
    RoleID INT NOT NULL,
    Status BIT DEFAULT 1, -- 1=active, 0=locked
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);



-- Bảng trung gian Parent – Student (N-N)
CREATE TABLE ParentStudents (
    ParentID INT NOT NULL,
    StudentID INT NOT NULL,
    Relation NVARCHAR(50),
    PRIMARY KEY (ParentID, StudentID),
    FOREIGN KEY (ParentID) REFERENCES Users(UserID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

-- =========================
-- Bảng Classes & Enrollment
-- =========================
CREATE TABLE Classes (
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    ClassName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    ClassCode NVARCHAR(50) UNIQUE, -- để student nhập code join class
    CreatedBy INT NOT NULL, -- UserID của giảng viên
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

CREATE TABLE ClassEnrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    StudentID INT NOT NULL,
    EnrolledAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

-- =========================
-- Bảng Tài liệu
-- =========================
CREATE TABLE Materials (
    MaterialID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    Title NVARCHAR(200),
    FilePath NVARCHAR(255), -- hoặc URL
    UploadedBy INT NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserID)
);

-- =========================
-- Quiz & Assignment
-- =========================
CREATE TABLE Quizzes (
    QuizID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    Title NVARCHAR(200),
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

CREATE TABLE QuizQuestions (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuizID INT NOT NULL,
    QuestionText NVARCHAR(MAX),
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
);

CREATE TABLE QuizAnswers (
    AnswerID INT PRIMARY KEY IDENTITY(1,1),
    QuestionID INT NOT NULL,
    AnswerText NVARCHAR(MAX),
    IsCorrect BIT,
    FOREIGN KEY (QuestionID) REFERENCES QuizQuestions(QuestionID)
);

CREATE TABLE QuizResults (
    ResultID INT PRIMARY KEY IDENTITY(1,1),
    QuizID INT NOT NULL,
    StudentID INT NOT NULL,
    Score DECIMAL(5,2),
    Feedback NVARCHAR(MAX) NULL, -- feedback từ giáo viên
    SubmittedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

CREATE TABLE Assignments (
    AssignmentID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    Title NVARCHAR(200),
    Description NVARCHAR(MAX),
    DueDate DATETIME,
    CreatedBy INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

CREATE TABLE AssignmentSubmissions (
    SubmissionID INT PRIMARY KEY IDENTITY(1,1),
    AssignmentID INT NOT NULL,
    StudentID INT NOT NULL,
    FilePath NVARCHAR(255),
    SubmittedAt DATETIME DEFAULT GETDATE(),
    Grade DECIMAL(5,2) NULL,
    Feedback NVARCHAR(MAX) NULL,
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

-- =========================
-- Bảng Events (Lịch học/thi)
-- =========================
CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    Title NVARCHAR(200),
    EventType NVARCHAR(50), -- Học / Kiểm tra
    StartTime DATETIME,
    EndTime DATETIME,
    CreatedBy INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- =========================
-- Bảng Reports
-- =========================
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReporterID INT NOT NULL,
    ReportType NVARCHAR(50), -- từ GV, SV, PH
    Content NVARCHAR(MAX),
    Status NVARCHAR(50) DEFAULT 'Pending', -- Pending, Resolved
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ReporterID) REFERENCES Users(UserID)
);

-- =========================
-- Bảng Achievements (thành tích của học sinh)
-- =========================
CREATE TABLE Achievements (
    AchievementID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    Title NVARCHAR(200),
    Description NVARCHAR(MAX),
    AwardedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

-- =========================
-- Bảng Statistics (thống kê điểm cho GV/HS)
-- =========================
CREATE TABLE ScoreStatistics (
    StatID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    AvgAssignmentScore DECIMAL(5,2) NULL,
    AvgQuizScore DECIMAL(5,2) NULL,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

-- =========================
-- Bảng DashboardConfig (cấu hình trang chủ GV)
-- =========================
CREATE TABLE DashboardConfig (
    ConfigID INT PRIMARY KEY IDENTITY(1,1),
    InstructorID INT NOT NULL,
    ShowUpcomingEvents BIT DEFAULT 1,
    ShowAssignments BIT DEFAULT 1,
    ShowReports BIT DEFAULT 1,
    FOREIGN KEY (InstructorID) REFERENCES Users(UserID)
);
------------------------------
-- Bảng reset mật khẩu:
CREATE TABLE TokenForgetPassword (
    TokenID INT PRIMARY KEY IDENTITY(1,1),
    Token VARCHAR(255) NOT NULL,
    ExpiryTime DATETIME NOT NULL,
    IsUsed BIT NOT NULL DEFAULT 0,
    UserID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

