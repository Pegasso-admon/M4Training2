-- =====================================================
-- SISTEMA DE GESTIÓN ACADÉMICA UNIVERSITARIA
-- Universidad Virtual "Aprende Online"
-- =====================================================

-- PASO 1: Crear la base de datos
CREATE DATABASE gestion_academica_universidad;
USE gestion_academica_universidad;

-- =====================================================
-- PASO 2: Diseño de tablas con restricciones
-- =====================================================

-- Tabla: estudiantes
CREATE TABLE estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    genero ENUM('M', 'F', 'Otro') NOT NULL,
    identificacion VARCHAR(20) UNIQUE NOT NULL,
    carrera VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    CHECK (fecha_nacimiento < fecha_ingreso)
);

-- Tabla: docentes
CREATE TABLE docentes (
    id_docente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(100) UNIQUE NOT NULL,
    departamento_academico VARCHAR(50) NOT NULL,
    anios_experiencia INT NOT NULL CHECK (anios_experiencia >= 0)
);

-- Tabla: cursos
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    creditos INT NOT NULL CHECK (creditos > 0),
    semestre INT NOT NULL CHECK (semestre BETWEEN 1 AND 10),
    id_docente INT NOT NULL,
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
);

-- Tabla: inscripciones
CREATE TABLE inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    calificacion_final DECIMAL(3,1) CHECK (calificacion_final BETWEEN 0.0 AND 5.0),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    UNIQUE(id_estudiante, id_curso)
);

-- =====================================================
-- PASO 3: Inserción de datos
-- =====================================================

-- Insertar 5 estudiantes
INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso) VALUES
('Ana María González', 'ana.gonzalez@estudiante.edu', 'F', '1234567890', 'Ingeniería de Sistemas', '2000-05-15', '2022-02-01'),
('Carlos Alberto Rodríguez', 'carlos.rodriguez@estudiante.edu', 'M', '1234567891', 'Administración de Empresas', '1999-08-20', '2021-08-15'),
('Laura Patricia Martínez', 'laura.martinez@estudiante.edu', 'F', '1234567892', 'Psicología', '2001-03-10', '2023-01-20'),
('Diego Fernando López', 'diego.lopez@estudiante.edu', 'M', '1234567893', 'Ingeniería de Sistemas', '2000-11-25', '2022-02-01'),
('María José Silva', 'maria.silva@estudiante.edu', 'F', '1234567894', 'Administración de Empresas', '2002-01-08', '2023-08-15');

-- Insertar 3 docentes
INSERT INTO docentes (nombre_completo, correo_institucional, departamento_academico, anios_experiencia) VALUES
('Dr. Roberto Pérez', 'roberto.perez@universidad.edu', 'Ingeniería', 8),
('Mg. Sandra Ramírez', 'sandra.ramirez@universidad.edu', 'Ciencias Empresariales', 6),
('Dr. Luis Fernando Castro', 'luis.castro@universidad.edu', 'Ciencias Sociales', 12);

-- Insertar 4 cursos
INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente) VALUES
('Programación Avanzada', 'PROG001', 4, 3, 1),
('Gestión Empresarial', 'GES001', 3, 2, 2),
('Psicología Organizacional', 'PSI001', 3, 4, 3),
('Base de Datos', 'BD001', 4, 4, 1);

-- Insertar 8 inscripciones distribuidas
INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion_final) VALUES
(1, 1, '2022-02-15', 4.5),
(1, 4, '2022-08-15', 4.8),
(2, 2, '2021-08-25', 3.8),
(2, 1, '2022-02-15', 3.2),
(3, 3, '2023-02-01', 4.2),
(4, 1, '2022-02-15', 4.0),
(4, 4, '2022-08-15', 4.6),
(5, 2, '2023-08-25', 3.9);

-- =====================================================
-- PASO 4: Consultas básicas y manipulación
-- =====================================================

-- Obtener listado de todos los estudiantes con sus inscripciones y cursos (JOIN)
SELECT 
    e.nombre_completo AS estudiante,
    c.nombre AS curso,
    c.codigo,
    i.calificacion_final,
    d.nombre_completo AS docente
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
JOIN docentes d ON c.id_docente = d.id_docente
ORDER BY e.nombre_completo;

-- Listar cursos dictados por docentes con más de 5 años de experiencia
SELECT 
    c.nombre AS curso,
    c.codigo,
    d.nombre_completo AS docente,
    d.anios_experiencia
FROM cursos c
JOIN docentes d ON c.id_docente = d.id_docente
WHERE d.anios_experiencia > 5
ORDER BY d.anios_experiencia DESC;

-- Obtener promedio de calificaciones por curso (GROUP BY + AVG)
SELECT 
    c.nombre AS curso,
    c.codigo,
    AVG(i.calificacion_final) AS promedio_curso,
    COUNT(i.id_inscripcion) AS total_estudiantes
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
WHERE i.calificacion_final IS NOT NULL
GROUP BY c.id_curso, c.nombre, c.codigo
ORDER BY promedio_curso DESC;

-- Mostrar estudiantes inscritos en más de un curso (HAVING COUNT(*) > 1)
SELECT 
    e.nombre_completo AS estudiante,
    e.carrera,
    COUNT(i.id_inscripcion) AS total_cursos
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo, e.carrera
HAVING COUNT(i.id_inscripcion) > 1
ORDER BY total_cursos DESC;

-- Agregar nueva columna estado_academico a la tabla estudiantes (ALTER TABLE)
ALTER TABLE estudiantes 
ADD COLUMN estado_academico ENUM('Activo', 'Inactivo', 'Graduado') DEFAULT 'Activo';

-- Actualizar el estado académico de algunos estudiantes
UPDATE estudiantes 
SET estado_academico = 'Activo' 
WHERE id_estudiante IN (1, 2, 3, 4, 5);

-- Simular eliminación de un docente y observar efecto en cursos (comentado para evitar errores)
-- DELETE FROM docentes WHERE id_docente = 3;

-- Consultar cursos con más de 2 estudiantes inscritos (GROUP BY + COUNT + HAVING)
SELECT 
    c.nombre AS curso,
    c.codigo,
    COUNT(i.id_estudiante) AS total_estudiantes,
    AVG(i.calificacion_final) AS promedio_calificaciones
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre, c.codigo
HAVING COUNT(i.id_estudiante) >= 2
ORDER BY total_estudiantes DESC;

-- =====================================================
-- PASO 5: Subconsultas y funciones avanzadas
-- =====================================================

-- Obtener estudiantes con calificación promedio superior al promedio general (AVG + subconsulta)
SELECT 
    e.nombre_completo AS estudiante,
    e.carrera,
    AVG(i.calificacion_final) AS promedio_estudiante,
    (SELECT AVG(calificacion_final) FROM inscripciones WHERE calificacion_final IS NOT NULL) AS promedio_general
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
WHERE i.calificacion_final IS NOT NULL
GROUP BY e.id_estudiante, e.nombre_completo, e.carrera
HAVING AVG(i.calificacion_final) > (
    SELECT AVG(calificacion_final) 
    FROM inscripciones 
    WHERE calificacion_final IS NOT NULL
)
ORDER BY promedio_estudiante DESC;

-- Mostrar nombres de carreras con estudiantes inscritos en cursos del semestre 2 o posterior (IN + EXISTS)
SELECT DISTINCT e.carrera
FROM estudiantes e
WHERE EXISTS (
    SELECT 1 
    FROM inscripciones i
    JOIN cursos c ON i.id_curso = c.id_curso
    WHERE i.id_estudiante = e.id_estudiante 
    AND c.semestre >= 2
);

-- Utilizar funciones como ROUND, SUM, MAX, MIN y COUNT para explorar indicadores
SELECT 
    'INDICADORES GENERALES DEL SISTEMA' AS reporte,
    COUNT(DISTINCT e.id_estudiante) AS total_estudiantes,
    COUNT(DISTINCT d.id_docente) AS total_docentes,
    COUNT(DISTINCT c.id_curso) AS total_cursos,
    COUNT(i.id_inscripcion) AS total_inscripciones,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_general,
    MAX(i.calificacion_final) AS calificacion_maxima,
    MIN(i.calificacion_final) AS calificacion_minima,
    SUM(c.creditos) AS total_creditos_ofertados
FROM estudiantes e
CROSS JOIN docentes d
CROSS JOIN cursos c
LEFT JOIN inscripciones i ON c.id_curso = i.id_curso;

-- =====================================================
-- PASO 6: Crear vista
-- =====================================================

-- Crear vista historial académico
CREATE VIEW vista_historial_academico AS
SELECT 
    e.nombre_completo AS nombre_estudiante,
    c.nombre AS nombre_curso,
    d.nombre_completo AS nombre_docente,
    c.semestre,
    i.calificacion_final,
    c.creditos,
    i.fecha_inscripcion
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
JOIN docentes d ON c.id_docente = d.id_docente
ORDER BY e.nombre_completo, c.semestre;

-- Consultar la vista creada
SELECT * FROM vista_historial_academico;

-- =====================================================
-- PASO 7: Control de acceso y transacciones
-- =====================================================

-- 1. Crear rol y asignar permisos de solo lectura sobre la vista
CREATE USER 'revisor_academico'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT ON gestion_academica_universidad.vista_historial_academico TO 'revisor_academico'@'localhost';

-- 2. Revocar permisos de modificación sobre la tabla inscripciones
REVOKE INSERT, UPDATE, DELETE ON gestion_academica_universidad.inscripciones FROM 'revisor_academico'@'localhost';

-- 3. Simular operación de actualización de calificaciones usando transacciones
START TRANSACTION;

-- Crear un savepoint antes de las actualizaciones
SAVEPOINT antes_actualizacion_calificaciones;

-- Actualizar algunas calificaciones
UPDATE inscripciones 
SET calificacion_final = 4.7 
WHERE id_estudiante = 1 AND id_curso = 1;

UPDATE inscripciones 
SET calificacion_final = 4.9 
WHERE id_estudiante = 1 AND id_curso = 4;

-- Verificar los cambios
SELECT 
    e.nombre_completo,
    c.nombre AS curso,
    i.calificacion_final
FROM inscripciones i
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
WHERE e.id_estudiante = 1;

-- Confirmar los cambios
COMMIT;

-- =====================================================
-- CONSULTAS ADICIONALES PARA ANÁLISIS AVANZADO
-- =====================================================

-- Análisis por carrera
SELECT 
    e.carrera,
    COUNT(DISTINCT e.id_estudiante) AS total_estudiantes,
    COUNT(i.id_inscripcion) AS total_inscripciones,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_carrera,
    MAX(i.calificacion_final) AS mejor_calificacion,
    MIN(i.calificacion_final) AS menor_calificacion
FROM estudiantes e
LEFT JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
WHERE i.calificacion_final IS NOT NULL
GROUP BY e.carrera
ORDER BY promedio_carrera DESC;

-- Rendimiento por docente
SELECT 
    d.nombre_completo AS docente,
    d.departamento_academico,
    COUNT(DISTINCT c.id_curso) AS cursos_dictados,
    COUNT(i.id_inscripcion) AS total_estudiantes_atendidos,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_calificaciones
FROM docentes d
JOIN cursos c ON d.id_docente = c.id_docente
LEFT JOIN inscripciones i ON c.id_curso = i.id_curso
WHERE i.calificacion_final IS NOT NULL
GROUP BY d.id_docente, d.nombre_completo, d.departamento_academico
ORDER BY promedio_calificaciones DESC;

-- Estudiantes con mejor rendimiento (TOP 3)
SELECT 
    e.nombre_completo AS estudiante,
    e.carrera,
    COUNT(i.id_inscripcion) AS cursos_tomados,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_general,
    MAX(i.calificacion_final) AS mejor_nota
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
WHERE i.calificacion_final IS NOT NULL
GROUP BY e.id_estudiante, e.nombre_completo, e.carrera
ORDER BY promedio_general DESC, cursos_tomados DESC
LIMIT 3;

-- =====================================================
-- VERIFICACIONES FINALES
-- =====================================================

-- Mostrar estructura de todas las tablas
SHOW TABLES;
DESCRIBE estudiantes;
DESCRIBE docentes;
DESCRIBE cursos;
DESCRIBE inscripciones;

-- Verificar la vista creada
SHOW CREATE VIEW vista_historial_academico;

-- Conteo final de registros
SELECT 
    'estudiantes' AS tabla, COUNT(*) AS total_registros FROM estudiantes
UNION ALL
SELECT 
    'docentes' AS tabla, COUNT(*) AS total_registros FROM docentes
UNION ALL
SELECT 
    'cursos' AS tabla, COUNT(*) AS total_registros FROM cursos
UNION ALL
SELECT 
    'inscripciones' AS tabla, COUNT(*) AS total_registros FROM inscripciones;