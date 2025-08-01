# University Academic Management System

## 📚 Project Overview

The **University Academic Management System** is a comprehensive relational database solution designed for "Aprende Online" Virtual University. This system centralizes academic information management, replacing error-prone spreadsheet systems with a robust, scalable database infrastructure.

### 🎯 Main Objectives

- **Centralize** student, faculty, course, and enrollment data
- **Eliminate** data inconsistencies and registration errors
- **Improve** academic performance analysis capabilities
- **Facilitate** efficient academic administration
- **Enable** advanced reporting and analytics

## 🏗️ Database Architecture

### Entity Relationship Model

The system is built around four core entities with well-defined relationships:

```
STUDENTS (1) ←→ (N) ENROLLMENTS (N) ←→ (1) COURSES (N) ←→ (1) PROFESSORS
```

### 📋 Table Structures

#### 1. **Students Table** (`estudiantes`)
| Field | Type | Constraints |
|-------|------|-------------|
| `id_estudiante` | INT | PRIMARY KEY, AUTO_INCREMENT |
| `nombre_completo` | VARCHAR(100) | NOT NULL |
| `correo_electronico` | VARCHAR(100) | UNIQUE, NOT NULL |
| `genero` | ENUM('M','F','Otro') | NOT NULL |
| `identificacion` | VARCHAR(20) | UNIQUE, NOT NULL |
| `carrera` | VARCHAR(50) | NOT NULL |
| `fecha_nacimiento` | DATE | NOT NULL |
| `fecha_ingreso` | DATE | NOT NULL |
| `estado_academico` | ENUM | DEFAULT 'Activo' |

**Business Rules:**
- Birth date must be before enrollment date
- Email addresses must be unique across the system
- Academic status tracks student progression

#### 2. **Professors Table** (`docentes`)
| Field | Type | Constraints |
|-------|------|-------------|
| `id_docente` | INT | PRIMARY KEY, AUTO_INCREMENT |
| `nombre_completo` | VARCHAR(100) | NOT NULL |
| `correo_institucional` | VARCHAR(100) | UNIQUE, NOT NULL |
| `departamento_academico` | VARCHAR(50) | NOT NULL |
| `anios_experiencia` | INT | NOT NULL, CHECK >= 0 |

**Business Rules:**
- Experience years cannot be negative
- Each professor belongs to one academic department
- Institutional email must be unique

#### 3. **Courses Table** (`cursos`)
| Field | Type | Constraints |
|-------|------|-------------|
| `id_curso` | INT | PRIMARY KEY, AUTO_INCREMENT |
| `nombre` | VARCHAR(100) | NOT NULL |
| `codigo` | VARCHAR(10) | UNIQUE, NOT NULL |
| `creditos` | INT | NOT NULL, CHECK > 0 |
| `semestre` | INT | CHECK BETWEEN 1 AND 10 |
| `id_docente` | INT | FOREIGN KEY → docentes |

**Business Rules:**
- Course codes must be unique
- Credits must be positive
- Semester range: 1-10
- Each course assigned to one professor

#### 4. **Enrollments Table** (`inscripciones`)
| Field | Type | Constraints |
|-------|------|-------------|
| `id_inscripcion` | INT | PRIMARY KEY, AUTO_INCREMENT |
| `id_estudiante` | INT | FOREIGN KEY → estudiantes |
| `id_curso` | INT | FOREIGN KEY → cursos |
| `fecha_inscripcion` | DATE | NOT NULL |
| `calificacion_final` | DECIMAL(3,1) | CHECK BETWEEN 0.0 AND 5.0 |

**Business Rules:**
- Students cannot enroll twice in the same course
- Final grades range: 0.0 - 5.0
- Enrollment date is mandatory

## 🚀 Implementation Steps

### Step 1: Database Creation and Setup
```sql
CREATE DATABASE gestion_academica_universidad;
USE gestion_academica_universidad;
```

### Step 2: Table Creation with Constraints
- Create all four tables with proper data types
- Implement primary keys, foreign keys, and check constraints
- Ensure referential integrity

### Step 3: Sample Data Insertion
- **5 Students** from different majors
- **3 Professors** with varying experience levels
- **4 Courses** across different semesters
- **8 Enrollments** distributed among students and courses

### Step 4: Basic Queries and Data Manipulation
- **JOIN Operations**: Combine data from multiple tables
- **Aggregation Functions**: AVG(), SUM(), COUNT(), MAX(), MIN()
- **Filtering**: WHERE, ORDER BY, BETWEEN, IN, LIKE, IS NULL
- **Grouping**: GROUP BY with HAVING clauses
- **Schema Modification**: ALTER TABLE operations

### Step 5: Advanced Queries and Subqueries
- **Performance Analysis**: Students above average grades
- **Complex Filtering**: EXISTS, IN with subqueries
- **Statistical Functions**: ROUND, comprehensive analytics

### Step 6: Views Creation
- **Academic History View**: Complete student academic records
- **Consolidated Reporting**: Easy access to historical data

### Step 7: Security and Transaction Management
- **User Roles**: Academic reviewer with read-only permissions
- **Access Control**: GRANT and REVOKE commands
- **Transaction Safety**: BEGIN, SAVEPOINT, COMMIT, ROLLBACK

## 📊 Key Features and Capabilities

### 🔍 Advanced Analytics

1. **Student Performance Analysis**
   - Individual and overall GPA calculations
   - Above-average student identification
   - Performance trends by major

2. **Course Effectiveness Metrics**
   - Average grades per course
   - Enrollment statistics
   - Professor performance indicators

3. **Administrative Reports**
   - Students enrolled in multiple courses
   - Course capacity analysis
   - Department-wise statistics

### 🛡️ Data Integrity Features

- **Referential Integrity**: Foreign key relationships prevent orphaned records
- **Data Validation**: Check constraints ensure data quality
- **Unique Constraints**: Prevent duplicate students and course codes
- **Transaction Safety**: ACID compliance for data consistency

### 🔐 Security Implementation

- **Role-Based Access Control**: Different permission levels
- **Data Privacy**: Secure handling of student information
- **Audit Trail**: Transaction logging capabilities

## 📈 Sample Queries and Use Cases

### Academic Performance Analysis
```sql
-- Students with above-average performance
SELECT e.nombre_completo, AVG(i.calificacion_final) as promedio
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante
HAVING AVG(i.calificacion_final) > (SELECT AVG(calificacion_final) FROM inscripciones);
```

### Course Enrollment Statistics
```sql
-- Courses with highest enrollment
SELECT c.nombre, COUNT(i.id_estudiante) as total_estudiantes
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso
ORDER BY total_estudiantes DESC;
```

### Professor Workload Analysis
```sql
-- Professor performance metrics
SELECT d.nombre_completo, COUNT(DISTINCT c.id_curso) as cursos_dictados,
       AVG(i.calificacion_final) as promedio_estudiantes
FROM docentes d
JOIN cursos c ON d.id_docente = c.id_docente
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY d.id_docente;
```

## 🗂️ Views and Reporting

### Academic History View
```sql
CREATE VIEW vista_historial_academico AS
SELECT 
    e.nombre_completo AS nombre_estudiante,
    c.nombre AS nombre_curso,
    d.nombre_completo AS nombre_docente,
    c.semestre,
    i.calificacion_final
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
JOIN docentes d ON c.id_docente = d.id_docente;
```

## 🔧 Installation and Setup

### Prerequisites
- MySQL Server 8.0 or higher
- MySQL Workbench (recommended) or any SQL client
- Sufficient privileges to create databases and users

### Installation Steps

1. **Clone or Download** the SQL script file
2. **Connect** to your MySQL server
3. **Execute** the complete SQL script
4. **Verify** table creation and data insertion
5. **Test** sample queries to ensure proper functionality

## 📝 Usage Examples

### Adding New Students
```sql
INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso)
VALUES ('New Student Name', 'email@student.edu', 'M', '1234567895', 'Computer Science', '2001-06-15', '2024-02-01');
```

### Enrolling Students in Courses
```sql
INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion)
VALUES (1, 2, '2024-02-15');
```

### Updating Final Grades
```sql
UPDATE inscripciones 
SET calificacion_final = 4.2 
WHERE id_estudiante = 1 AND id_curso = 2;
```

## 🔍 Performance Optimization

### Recommended Indexes
```sql
-- Optimize frequent queries
CREATE INDEX idx_estudiante_carrera ON estudiantes(carrera);
CREATE INDEX idx_curso_semestre ON cursos(semestre);
CREATE INDEX idx_inscripcion_fecha ON inscripciones(fecha_inscripcion);
```

### Query Optimization Tips
- Use appropriate indexes for frequent WHERE clauses
- Limit result sets with LIMIT when appropriate
- Use EXPLAIN to analyze query execution plans
- Consider partitioning for large datasets

## 🧪 Testing and Validation

### Data Integrity Tests
- Verify foreign key constraints
- Test check constraints with invalid data
- Validate unique constraints

### Functional Tests
- Test all CRUD operations
- Verify complex queries return expected results
- Test transaction rollback scenarios

## 🚨 Troubleshooting

### Common Issues

1. **Foreign Key Errors**
   - Ensure referenced records exist before insertion
   - Check foreign key constraint definitions

2. **Data Type Mismatches**
   - Verify data types match column definitions
   - Check date formats (YYYY-MM-DD)

3. **Permission Errors**
   - Verify user has necessary database privileges
   - Check GRANT statements execution

## 🔮 Future Enhancements

### Planned Features
- **Audit Logging**: Track all data modifications
- **Grade History**: Maintain grade change history
- **Course Prerequisites**: Implement course dependency management
- **Automated Notifications**: Email alerts for important events
- **Mobile API**: REST API for mobile applications

### Scalability Considerations
- **Horizontal Partitioning**: Split large tables by date ranges
- **Read Replicas**: Implement read-only database replicas
- **Caching Layer**: Add Redis for frequently accessed data
- **Archive Strategy**: Move old data to archive tables

---

## 📞 Support

For questions, issues, or contributions, please refer to the training materials or contact the academic support team.

**Happy Coding! 🚀**