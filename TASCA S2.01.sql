/******************************************
Exercici 2
Utilitzant JOIN realitzaràs les següents consultes:
*******************************************/

-- 2.1 Llistat dels països que estan fent compres.
SELECT distinct c.country as "Pais" 
FROM company c                    
JOIN transaction t                
ON c.id = t.company_id     
WHERE t.declined = 0
ORDER BY c.country;      		    


-- 2.2 Des de quants països es realitzen les compres.
SELECT count(distinct c.country) as "Total Paises" 
FROM company c             
JOIN transaction t        
ON c.id = t.company_id     
WHERE t.declined = 0;     
   
   
     
-- 2.3 Identifica la companyia amb la mitjana més gran de vendes.
SELECT c.company_name as "Companya", ROUND(AVG(t.amount),2) as promedio_ventas 
FROM company c
JOIN transaction t         
ON c.id = t.company_id     
WHERE t.declined = 0
GROUP BY c.company_name      
ORDER BY promedio_ventas DESC 
LIMIT 1;                    

/********************************************************************************************
- Exercici 3
Utilitzant només subconsultes (sense utilitzar JOIN):
*****************************************************************/

-- 3.1 Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT t.id AS transaction_id, t.company_id, amount,
   (SELECT c.country FROM company c WHERE c.id = t.company_id) AS "País"
FROM transaction t
-- WHERE t.declined = 0 AND t.company_id IN
WHERE t.company_id IN
(SELECT c.id
 FROM company c
 WHERE c.country = "Germany") ;


-- 3.2 Llista les empreses que han realitzat transaccions per un amount superior a la mitjana
-- de totes les transaccions.
SELECT c.company_name
FROM company c
WHERE c.id IN 
(SELECT t.company_ID
FROM transaction t
 WHERE t.declined = 0 AND amount > 
	(SELECT AVG(amount) 
	FROM transaction)
)
ORDER BY c.company_name;


-- 3.3 Eminaran del sistema les empreses que no tenen transaccions registrades,
-- entrega el llistat d'aquestes empreses.

SELECT c.company_name as "Empresa sin Transacciones"
FROM company c
WHERE NOT EXISTS (
    SELECT t.company_id
    FROM transaction t
    WHERE t.company_id = c.id);

/*****************************************************************
NIVELL 2
******************************************************************/
/*****************************************************************
Exercici 1
Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes
Mostra la data de cada transacció juntament amb el total de les vendes.
*******************************************************************/
SELECT DATE(timestamp) as fecha, SUM(amount) as ventas_totales
     FROM transaction
	 WHERE declined = 0
	 GROUP BY fecha
	 ORDER BY ventas_totales DESC
     LIMIT 5;

/******************************************************
Exercici 2
Quina és la mitjana de vendes per país?
Presenta els resultats ordenats de major a menor mitjà.
******************************************************/
SELECT c.country, ROUND(AVG(t.amount),2) as promedio_ventas
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.country
ORDER BY promedio_ventas DESC;

/**********************************************************************************
Exercici 3
En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer
competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions
realitzades per empreses que estan situades en el mateix país que aquesta companyia.
Mostra el llistat aplicant JOIN i subconsultes.
Mostra el llistat aplicant solament subconsultes.
************************************************************************************/ 
-- Aplicando JOIN y subconsultas
SELECT *
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE c.country =
	(SELECT c.country
	FROM company c
	WHERE c.company_name = 'Non Institute')
ORDER BY c.company_name;

-- Aplicando sólo subconsultas
SELECT *
FROM transaction t
WHERE t.company_id IN
	(SELECT c.id
	FROM company c
	WHERE c.country IN
		(SELECT c.country
		FROM company c
				WHERE c.company_name = 'Non Institute'))
ORDER BY t.company_id;

/***********************************************************************************
NIVELL 3
Exercici 1
Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar
transaccions amb un valor comprès entre 100 i 200 euros i en alguna
d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022.
Ordena els resultats de major a menor quantitat.
************************************************************************************/
SELECT c.company_name as compañia, c.phone as teléfono, c.country as país,
       DATE(T.timestamp) as fecha, t.amount as monto
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0 AND t.amount BETWEEN 100 AND 200
AND DATE(t.timestamp) IN ('2021-04-29', '2021-07-20','2022-03-13')
ORDER BY t.amount DESC;



/************************************************************************************************
Exercici 2
Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses,
però el departament de recursos humans és exigent i vol un llistat de les empreses
on especifiquis si tenen més de 4 transaccions o menys.
*************************************************************************************************/
SELECT c.id as id_compañia, c.company_name as nombre_compañia, count(t.id) as total_trans,
	CASE
		WHEN count(t.id) > 4 THEN 'La empresa tiene más de 4 transacciones'
        WHEN count(t.id) = 4 THEN 'La empresa tiene 4 transacciones'
		ELSE 'La empresa tiene menos de 4 transacciones'
	END as Descripción
FROM company c
JOIN transaction t
    ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY
      c.id, c.company_name;

/* FIN SPRINT 2 */



