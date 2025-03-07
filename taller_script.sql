-- a) Listado de todas las columnas de todos los empleados
SELECT * FROM employees;

-- b) Listado de empleados ordenado por nombre y apellido
SELECT * FROM employees ORDER BY first_name, last_name;

-- c) Empleados cuyo nombre empieza con 'K'
SELECT * FROM employees WHERE first_name LIKE 'K%';

-- d) Igual al anterior, pero ordenado por nombre y apellido
SELECT * FROM employees WHERE first_name LIKE 'K%' ORDER BY first_name, last_name;

-- e) Cantidad de empleados por departamento
SELECT department_id, COUNT(*) AS num_employees FROM employees GROUP BY department_id;

-- f) Máximo número de empleados en un departamento
SELECT MAX(num_employees) FROM (SELECT department_id, COUNT(*) AS num_employees FROM employees GROUP BY department_id) AS dept_count;

-- g) ID, nombre de empleados y nombre del departamento
SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM employees e JOIN departments d ON e.department_id = d.department_id;

-- h) Número, nombre y salario de empleados del departamento SALES
SELECT employee_id, first_name, last_name, salary FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'SALES');

-- i) Igual al anterior, pero ordenado de mayor a menor salario
SELECT employee_id, first_name, last_name, salary FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'SALES') ORDER BY salary DESC;

-- j) Número, nombre, salario y grado salarial de empleados
SELECT e.employee_id, e.first_name, e.last_name, e.salary, g.grade_level FROM employees e JOIN salary_grades g ON e.salary BETWEEN g.min_salary AND g.max_salary;

-- k) Empleados con grados salariales 2, 4 o 5
SELECT e.employee_id, e.first_name, g.grade_level FROM employees e JOIN salary_grades g ON e.salary BETWEEN g.min_salary AND g.max_salary WHERE g.grade_level IN (2, 4, 5);

-- l) ID del departamento con el promedio salarial ordenado de mayor a menor
SELECT department_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id ORDER BY avg_salary DESC;

-- m) Nombre del departamento con el promedio salarial ordenado de mayor a menor
SELECT d.department_name, AVG(e.salary) AS avg_salary FROM employees e JOIN departments d ON e.department_id = d.department_id GROUP BY d.department_name ORDER BY avg_salary DESC;

-- n) ID del departamento con más empleados
SELECT department_id FROM employees GROUP BY department_id ORDER BY COUNT(*) DESC LIMIT 1;

-- o) Jefes con su departamento
SELECT m.employee_id, m.first_name, d.department_name FROM employees m JOIN departments d ON m.employee_id = d.manager_id;

-- p) Diferencia de grado salarial entre empleado y su jefe
SELECT e.first_name, e.salary, g1.grade_level AS emp_grade, m.salary, g2.grade_level AS mgr_grade, g2.grade_level - g1.grade_level AS grade_diff FROM employees e JOIN employees m ON e.manager_id = m.employee_id JOIN salary_grades g1 ON e.salary BETWEEN g1.min_salary AND g1.max_salary JOIN salary_grades g2 ON m.salary BETWEEN g2.min_salary AND g2.max_salary;

-- q) Departamentos con al menos un empleado que gana más de 3000
SELECT DISTINCT d.department_id, d.department_name FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE e.salary > 3000;

-- r) Departamentos con al menos dos empleados que ganan más de 2500
SELECT department_id, department_name FROM (SELECT department_id, COUNT(*) AS count FROM employees WHERE salary > 2500 GROUP BY department_id) AS temp WHERE count >= 2;

-- s) Empleados que ganan más que su jefe
SELECT e.employee_id, e.first_name FROM employees e JOIN employees m ON e.manager_id = m.employee_id WHERE e.salary > m.salary;

-- t) Departamentos con empleados que ganan más de 3000 y su cantidad
SELECT d.department_id, d.department_name, COUNT(*) FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE e.salary > 3000 GROUP BY d.department_id, d.department_name;

-- u) Departamentos donde todos los empleados ganan más de 3000
SELECT d.department_id, d.department_name FROM departments d WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id AND e.salary <= 3000);

-- v) Departamentos donde todos ganan más de 3000 y al menos un jefe gana más de 5000
SELECT d.department_id, d.department_name FROM departments d WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id AND e.salary <= 3000) AND EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id AND e.salary > 5000 AND e.employee_id IN (SELECT manager_id FROM employees));

-- w) Empleados fuera del departamento 80 que ganan más que cualquiera en él
SELECT employee_id, first_name FROM employees WHERE department_id <> 80 AND salary > (SELECT MAX(salary) FROM employees WHERE department_id = 80);
