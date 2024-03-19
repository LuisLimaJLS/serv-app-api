--FUNCION PARA OBTENER LA RUTA DE UNA ABONADO
CREATE OR REPLACE FUNCTION get_ruta_by_abonado("id_abonado" int8) 
RETURNS "pg_catalog"."text" AS $BODY$ 
DECLARE
  ruta TEXT :='';
BEGIN
  ruta := (select c.descripcion||' - '||s.descripcion||' - '||r.descripcion from canton c, sector s, ruta r, abonado ab
  WHERE s.id_canton=c.id and r.id_sector = s.id and ab.id_ruta=r.id
  and ab.id=$1);
RETURN ruta;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
SELECT * FROM get_ruta_by_abonado (115147);

--FUNCION PARA OBTEENR CLIETE POR ID
CREATE OR REPLACE FUNCTION get_cliente_by_id("id_cliente" int8) 
RETURNS "pg_catalog"."text" AS $BODY$ 
DECLARE
  cliente TEXT :='';
BEGIN
  cliente := (select cl.identificador||' - '||cl.nombres||' '||cl.apellidos from cliente cl WHERE cl.id = $ 1);
RETURN cliente;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
SELECT * FROM get_cliente_by_id (148163);

--FUNCION PARA OBTENER ABONADOS
CREATE OR REPLACE FUNCTION get_all_abonados() 
RETURNS TABLE(
  id int8 ,
  id_predio int8 ,
  id_categoria int4 ,
  nro_medidor varchar,
  estado int4,
  fecha_instalacion date ,
  marca_medidor varchar,
  direccion varchar,
  secuencia int8,
  observacion varchar,
  id_cliente int8 ,
  id_ruta int8 ,
  situacion varchar
) AS $BODY$
BEGIN
RETURN QUERY
SELECT 
  ab.ID,
  ab.id_predio,
  ab.id_categoria,
  ab.nro_medidor,
  ab.estado,
  ab.fecha_instalacion,
  ab.marca_medidor,
  ab.direccion,
  ab.secuencia,
  ab.observacion,
  ab.id_cliente,
  ab.id_ruta,
  ab.situacion 
FROM
  abonado ab
ORDER BY
  ab.ID;
END;
$BODY$ LANGUAGE plpgsql;

SELECT * FROM get_all_abonados();

--FUNCION PARA OBETER TODOS LOS ABONADOS CON DATA
CREATE OR REPLACE FUNCTION get_all_abonados_data() 
RETURNS TABLE(
  id int8 ,
  id_predio varchar ,
  id_categoria varchar ,
  nro_medidor varchar,
  estado int4,
  fecha_instalacion date ,
  marca_medidor varchar,
  direccion varchar,
  secuencia int8,
  observacion varchar,
  id_cliente varchar ,
  id_ruta varchar ,
  situacion varchar
) AS $BODY$
BEGIN
RETURN QUERY
SELECT 
  ab.ID,
  (SELECT clave  FROM predio pr WHERE pr.id = ab.id_predio) id_predio,
  (SELECT descripcion FROM categoria cat WHERE cat.id = ab.id_categoria) id_categoria,
  ab.nro_medidor,
  ab.estado,
  ab.fecha_instalacion,
  ab.marca_medidor,
  ab.direccion,
  ab.secuencia,
  ab.observacion,
  (SELECT * FROM get_cliente_by_id (ab.id_cliente))::VARCHAR id_cliente,
  (SELECT * FROM get_ruta_by_abonado (ab.id))::VARCHAR id_ruta,
  ab.situacion 
FROM
  abonado ab
ORDER BY
  ab.ID;
END;
$BODY$ LANGUAGE plpgsql;
select * from get_all_abonados_data();

-- FUNCION PARA OBETENER CUENTAS POR CI
CREATE OR REPLACE FUNCTION get_all_abonados_by_ci("identificador" text) 
RETURNS TABLE(
  id int8 ,
  id_predio varchar ,
  id_categoria varchar ,
  nro_medidor varchar,
  estado int4,
  fecha_instalacion date ,
  marca_medidor varchar,
  direccion varchar,
  secuencia int8,
  observacion varchar,
  id_cliente varchar ,
  id_ruta varchar ,
  situacion varchar
) AS $BODY$
BEGIN
RETURN QUERY
SELECT 
  ab.ID,
  (SELECT clave  FROM predio pr WHERE pr.id = ab.id_predio) id_predio,
  (SELECT descripcion FROM categoria cat WHERE cat.id = ab.id_categoria) id_categoria,
  ab.nro_medidor,
  ab.estado,
  ab.fecha_instalacion,
  ab.marca_medidor,
  ab.direccion,
  ab.secuencia,
  ab.observacion,
  (SELECT * FROM get_cliente_by_id (ab.id_cliente))::VARCHAR id_cliente,
  (SELECT * FROM get_ruta_by_abonado (ab.id))::VARCHAR id_ruta,
  ab.situacion 
FROM
  abonado ab
  INNER JOIN cliente cl on ab.id_cliente = cl.id
  and cl.identificador = $1
ORDER BY
  ab.ID;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_all_abonados_by_ci('5604816896');



-- FUNCION PARA OBETENER CLIENTE POR CI
CREATE OR REPLACE FUNCTION get_cliente_by_ci("ci" text) 
RETURNS TABLE(
  id int8,
  identificador varchar,
  apellidos varchar,
  nombres varchar,
	direccion varchar,
  fecha_nacimiento date,
  contrasena varchar,
	estado int4
) AS $BODY$
BEGIN
RETURN QUERY
SELECT 
	cl.id,
	cl.identificador,
	cl.apellidos,
	cl.nombres,
	cl.direccion,
	cl.fecha_nacimiento,
	cl.contrasena,
	cl.estado
FROM 
	cliente cl
WHERE 
	cl.identificador = $1
ORDER BY cl.ID;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_cliente_by_ci('5604816896');



----------------------------------------
--PROMEDIO DE CONSUMO DE LOS ULTIMOS N MESES DE UN MEDIDOR DESE UNA EMISION ESPECIFICA
CREATE OR REPLACE FUNCTION get_avg_by_abonado_emi("id_abo" int8, "id_emision" int8, "nro_meses" int4 ) 
RETURNS TABLE(
  id_abonado int8,
  nro_medidor varchar,
	promedio_consumo int4,
	promedio_valor float8
) AS $BODY$
BEGIN
RETURN QUERY
	SELECT  
	MAX(val.id) id_abonado,
	MAX(val.nro_medidor)::varchar nro_medidor,
	ROUND(SUM(val.consumo)/count(*))::INTEGER promedio_consumo,
	ROUND((SUM(val.valor)/count(*))::numeric , 2)::float8 promedio_valor
	FROM (
	SELECT 
	ab.id,
	ab.nro_medidor,
	pe.emision,
	ea.lectura_actual-ea.lectura_anterior consumo,
	f.valor
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	WHERE
	ab.id = $1
	and ea.id < $2
	ORDER BY ea.id desc
	limit $3) as val
	GROUP BY
	val.id,
	val.nro_medidor;
END;
$BODY$ LANGUAGE plpgsql;
select * from get_avg_by_abonado_emi(115147, 2161559, 6)

--ULTIMOS N CONSUMOS DE UN MEDIDOR
CREATE OR REPLACE FUNCTION get_emsion_by_abonado("id_abo" int8, "nro_meses" int4 ) 
RETURNS TABLE(
  id_abonado int8,
	id_emision int8,
  nro_medidor varchar,
	emision varchar,
	consumo int4,
	valor float8,
	promedio_consumo int4,
	promedio_valor float8
) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	ab.id id_abonado,
	ea.id id_emision,
	ab.nro_medidor,
	pe.emision,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor::float8,
	(select p1.promedio_consumo from get_avg_by_abonado_emi(ab.id, ea.id) p1)::int4 promedio_consumo,
	(select p2.promedio_valor from get_avg_by_abonado_emi(ab.id, ea.id) p2)::float8 promedio_valor
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	WHERE
	ab.id = $1
	--and ea.id < 2161559
	ORDER BY ea.id desc
	limit $2;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_emsion_by_abonado (115147, 10)

--LOS N MAXIMOS CONSUMOS DE UN MEDIDOR
CREATE OR REPLACE FUNCTION get_max_emsion_by_abonado("id_abo" int8, "nro_meses" int4 ) 
RETURNS TABLE(
  id_abonado int8,
	id_emision int8,
  nro_medidor varchar,
	emision varchar,
	consumo int4,
	valor float8,
	promedio_consumo int4,
	promedio_valor float8
) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	ab.id id_abonado,
	ea.id id_emision,
	ab.nro_medidor,
	pe.emision,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor::float8,
	(select p1.promedio_consumo from get_avg_by_abonado_emi(ab.id, ea.id) p1)::int4 promedio_consumo,
	(select p2.promedio_valor from get_avg_by_abonado_emi(ab.id, ea.id) p2)::float8 promedio_valor
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	WHERE
	ab.id = $1
	ORDER BY (ea.lectura_actual-ea.lectura_anterior) desc
	limit $2;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_max_emsion_by_abonado (115147, 6);

--PROMEDIO DE LOS RUBROS EMITIDOS EN LAS N ULTMIAS EMISIONES DE UN MEDIDOR

CREATE OR REPLACE FUNCTION get_rubros_avg_by_abonado("id_abo" int8, "nro_meses" int4 ) 
RETURNS TABLE(
  id_abonado int8,
  nro_medidor varchar,
	descripcion varchar,
	valor float8
) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	ab.id id_abonado,
	ab.nro_medidor, 
	r.descripcion,
	round((SUM(fd.cantidad * fd.valor_unitario)/COUNT(r.descripcion))::numeric, 2)::float8 valor
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN factura_detalle fd ON fd.id_factura=f.id
	INNER JOIN rubro r ON r.id=fd.id_rubro
	WHERE
	ea.id in (
	SELECT
	ea.id id_emision
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	WHERE
	ab.id = $1
	ORDER BY ea.id desc
	limit $2
	)
	GROUP BY
	ab.id,
	ab.nro_medidor,
	r.descripcion
	ORDER BY 4;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_rubros_avg_by_abonado(115147, 6) ;



----VER EL HISTORIA DE UN USUARIO POR NRO DE IDENTIFICADOR
CREATE OR REPLACE FUNCTION get_all_history_by_ci("identificador" text) 
RETURNS TABLE(
    id_abonado int8,
	id_emision int8,
    nro_medidor varchar,
	emision varchar,
	fecha_emision date,
	novedad varchar,
	lectura_actual int4,
	lectura_anterior int4,
	consumo int4,
	valor float8,
	estado int4,
	pagado int4,
	fecha_cobro date
) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	ab.id id_abonado,
	ea.id id_emision,
	ab.nro_medidor,
	pe.emision,
	ea.fecha_emision,
	ea.novedad,
	ea.lectura_actual::int4 consumo,
	ea.lectura_anterior::int4 consumo,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	f.fecha_cobro
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN cliente cl ON cl.id=ab.id_cliente
	WHERE
	cl.identificador = $1
	ORDER BY ea.fecha_emision desc;
	END;
$BODY$ LANGUAGE plpgsql;

select * from get_all_history_by_ci('5604816896') ;
----VER EL HISTORIAL DE UN USUARIO POR ABONADO
CREATE OR REPLACE FUNCTION get_all_history_by_abonado("id_ab" int8) 
RETURNS TABLE(
  id_abonado int8,
	id_emision int8,
  nro_medidor varchar,
	emision varchar,
	fecha_emision date,
	novedad varchar,
	lectura_actual int4,
	lectura_anterior int4,
	consumo int4,
	valor float8,
	estado int4,
	pagado int4,
	fecha_cobro date
) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	ab.id id_abonado,
	ea.id id_emision,
	ab.nro_medidor,
	pe.emision,
	ea.fecha_emision,
	ea.novedad,
	ea.lectura_actual::int4 consumo,
	ea.lectura_anterior::int4 consumo,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	f.fecha_cobro
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN cliente cl ON cl.id=ab.id_cliente
	WHERE
	ab.id = $1
	ORDER BY ea.fecha_emision desc;
	END;
$BODY$ LANGUAGE plpgsql;


select * from get_all_history_by_abonado(145965) ;





--nro medidor aleatorio
select ('MED-'||"substring"("upper"(MD5(random()::text)), 0, 10) ), * from abonado;