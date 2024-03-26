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

-- FUNCION PARA OBETENER CUENTAS POR SU ID
CREATE OR REPLACE FUNCTION get_all_abonados_by_id("id_abo" int8) 
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
  and ab.id = $1
ORDER BY
  ab.ID;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_all_abonados_by_id(117325);

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
  estado int4,
  correo_electronico varchar
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
	cl.estado,
	(select valor from contacto ct WHERE ct.id_cliente = cl.id and ct.descripcion = 'CORREO ELECTRONICO' limit 1) correo_electronico
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
	fecha_cobro date,
	nro_factura varchar
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
	ea.lectura_actual::int4 lectura_actual,
	ea.lectura_anterior::int4 lectura_anterior,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	f.fecha_cobro,
	f.nro_factura
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
	fecha_cobro date,
	nro_factura varchar
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
	ea.lectura_actual::int4 lectura_actual,
	ea.lectura_anterior::int4 lectura_anterior,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	f.fecha_cobro,
	f.nro_factura
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

select * from get_all_history_by_abonado(145965);



--FUNCION PARA HACER BUSQUEDASS
CREATE OR REPLACE FUNCTION get_all_search_by_ci("buscar" text,"identificador" text) 
RETURNS TABLE(
  id_abonado int8,
	id_emision int8,
  nro_medidor varchar,
	emision varchar,
	fecha_emision date,
	consumo int4,
	valor float8,
	estado int4,
	pagado int4,
	id_ruta varchar,
	id_predio varchar,
	id_categoria varchar,
	novedad varchar,
	lectura_actual int4,
	lectura_anterior int4,
	promedio_consumo int4,
	promedio_valor float8,
	fecha_cobro date
) AS $BODY$
BEGIN
IF 'full' = $1::text THEN
	RETURN QUERY 
  SELECT 
	ab.id id_abonado,
	ea.id id_emision,
	ab.nro_medidor,
	pe.emision::varchar,
	ea.fecha_emision,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	(SELECT * FROM get_ruta_by_abonado (ab.id))::VARCHAR id_ruta,
	(SELECT clave  FROM predio pr WHERE pr.id = ab.id_predio)::VARCHAR id_predio,
  (SELECT descripcion FROM categoria cat WHERE cat.id = ab.id_categoria)::VARCHAR id_categoria,
	ea.novedad,
	ea.lectura_actual::int4 lectura_actual,
	ea.lectura_anterior::int4 lectura_anterior,
	(select p1.promedio_consumo from get_avg_by_abonado_emi(ab.id, ea.id, 6) p1)::int4 promedio_consumo,
	(select p2.promedio_valor from get_avg_by_abonado_emi(ab.id, ea.id, 6) p2)::float8 promedio_valor,
	f.fecha_cobro
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN cliente cl ON cl.id=ab.id_cliente
	WHERE
	cl.identificador = $2
	ORDER BY ea.fecha_emision desc;
ELSE
RETURN QUERY 
  SELECT 
	ab.id id_abonado,
	ea.id id_emision,
	ab.nro_medidor,
	pe.emision,
	ea.fecha_emision,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	null::VARCHAR id_ruta, --(SELECT * FROM get_ruta_by_abonado (ab.id))::VARCHAR id_ruta,
	null::VARCHAR id_predio, --(SELECT clave  FROM predio pr WHERE pr.id = ab.id_predio) id_predio,
  null::VARCHAR id_categoria, --(SELECT descripcion FROM categoria cat WHERE cat.id = ab.id_categoria) id_categoria,
	null::VARCHAR novedad, --ea.novedad,
	null::int4 lectura_actual, --ea.lectura_actual::int4 lectura_actual,
	null::int4 lectura_anterior, --ea.lectura_anterior::int4 lectura_anterior,
	null::int4 promedio_consumo, --(select p1.promedio_consumo from get_avg_by_abonado_emi(ab.id, ea.id, 6) p1)::int4 promedio_consumo,
	null::float8 promedio_valor, --(select p2.promedio_valor from get_avg_by_abonado_emi(ab.id, ea.id, 6) p2)::float8 promedio_valor,
	null::date fecha_cobro -- f.fecha_cobro
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN cliente cl ON cl.id=ab.id_cliente
	WHERE
	cl.identificador = $2
	ORDER BY ea.fecha_emision desc;
END IF;
END;
$BODY$ LANGUAGE plpgsql;


select * from get_all_search_by_ci('full','2506716965001');


--FINCIOM PARA OTENER EL DETALLE DE LOS RUBROS DE LOS ULTIMOS N MESES DE UN ABONADO
CREATE OR REPLACE FUNCTION "public"."get_detail_values_by_abonado"("id_abo" int8, "nro_meses" int4)
  RETURNS TABLE("id_rubro" int8, "descripcion" varchar, "cantidad" float8, "valor_unitario" float8, "valor" float8) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	r.id id_rubro,
  r.descripcion,
	ROUND(SUM(fd.cantidad)::numeric,2)::float8 cantidad,
	ROUND((SUM(fd.valor_unitario)/SUM(fd.cantidad))::numeric,2)::float8 valor_unitario,
	ROUND(SUM(fd.cantidad * fd.valor_unitario)::numeric,2)::float8 valor
	from factura_detalle fd
	INNER JOIN rubro r ON fd.id_rubro = r.id
	WHERE fd.estado=1 and fd.id_factura in (
	SELECT 
	f.id
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	WHERE
	ab.id = $1
	ORDER BY ea.id desc
	limit $2)
	GROUP BY r.id, r.descripcion
	ORDER BY 5;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

	select * from get_detail_values_by_abonado (115147,6)

--FUNCION PARA OBTENER LOS DATOS DE UNA EMISION POR EL ID
CREATE OR REPLACE FUNCTION "public"."get_emsion_by_id"("id_emi" int8)
  RETURNS TABLE("id_abonado" int8, "id_emision" int8, "nro_medidor" varchar, "emision" varchar, "consumo" int4, "valor" float8, "promedio_consumo" int4, "promedio_valor" float8) AS $BODY$
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
	ea.id = $1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
	
select * from get_emsion_by_id(2161559);

--funcion para obtener los rubros de una determinada emision:
CREATE OR REPLACE FUNCTION "public"."get_detail_values_by_emision"("id_emi" int8)
  RETURNS TABLE("id_rubro" int8, "descripcion" varchar, "cantidad" float8, "valor_unitario" float8, "valor" float8) AS $BODY$
BEGIN
RETURN QUERY
	SELECT 
	r.id id_rubro,
	r.descripcion,
	fd.cantidad::float8 cantidad,
	fd.valor_unitario::float8 valor_unitario,
	(fd.cantidad *fd.valor_unitario)::float8 valor
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN factura_detalle fd on fd.id_factura=f.id
	INNER JOIN rubro r on fd.id_rubro = r.id
	WHERE
	fd.estado = 1
	and	ea.id = $1
	ORDER BY 5;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
	
select * from get_detail_values_by_emision(2148961);


--FUNCION PARA OBETENR LAS N EMISIONES ANTERIORES DESDE UNA ESPECIFICA:
CREATE OR REPLACE FUNCTION "public"."get_emsions_history_by_id"("id_emi" int8, "nro_meses" int4)
  RETURNS TABLE("id_abonado" int8, "id_emision" int8, "nro_medidor" varchar, "emision" varchar, "consumo" int4, "valor" float8, "promedio_consumo" int4, "promedio_valor" float8) AS $BODY$
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
	ab.id = (select ea2.id_abonado from emision_abonado ea2 WHERE ea2.id = $1)
	and ea.id <= $1
	ORDER BY ea.id desc
	limit $2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
	
select * from get_emsions_history_by_id(2136393, 6);

--FUNCION PARA OBTENER EL HISTORIAL DE UNA EMISION ESPECIFICA:
CREATE OR REPLACE FUNCTION get_history_by_emision("id_emi" int8) 
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
	fecha_cobro date,
	nro_factura varchar
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
	ea.lectura_actual::int4 lectura_actual,
	ea.lectura_anterior::int4 lectura_anterior,
	(ea.lectura_actual-ea.lectura_anterior)::int4 consumo,
	f.valor,
	f.estado,
	f.pagado,
	f.fecha_cobro,
	f.nro_factura
	FROM 
	abonado ab
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	INNER JOIN cliente cl ON cl.id=ab.id_cliente
	WHERE
	ea.id = $1
	ORDER BY ea.fecha_emision desc;
	END;
$BODY$ LANGUAGE plpgsql;

select * from get_history_by_emision(2136393);


--FUNCION PARA OBTENER LOS CONSUMOS QUE SUPERAN SU PROMEDO DE N MESES ATRAS
CREATE OR REPLACE FUNCTION get_max_emsion_alert_by_ci("ci" text, "nro_meses" int4 ) 
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
	INNER JOIN cliente cl ON cl.id = ab.id_cliente
	INNER JOIN emision_abonado ea ON ea.id_abonado = ab.id
	INNER JOIN periodo_emision_ruta per ON per.id =ea.id_periodo_emision_ruta
	INNER JOIN periodo_emision pe ON pe.id = per.id_periodo_emision
	INNER JOIN factura f ON f.id = ea.id_factura
	WHERE
	pe.id in (select pe2.id from periodo_emision pe2 ORDER BY pe2.id desc limit $2)
	and cl.identificador = $1
	and (((ea.lectura_actual-ea.lectura_anterior)::int4) > (select p1.promedio_consumo from get_avg_by_abonado_emi(ab.id, ea.id) p1)::int4)
	ORDER BY ea.id desc;
END;
$BODY$ LANGUAGE plpgsql;

select * from get_max_emsion_alert_by_ci ('2506716965001', 6);


--nro medidor aleatorio
select ('MED-'||"substring"("upper"(MD5(random()::text)), 0, 10) ), * from abonado;