DROP PROCEDURE IF EXISTS tSelectCumple;
CREATE PROCEDURE tSelectCumple(
	IN v_anio varchar(4),
	IN v_mes varchar(2),
	IN v_dia varchar(2),
	IN v_tipo varchar(5)
)
BEGIN
	DECLARE fecha_ahora varchar(10);

	DECLARE error int DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET error=1;
		SELECT "yes" error,"Transaccion no completada: tInsertPayment" msj;
	END;

	START TRANSACTION;
	SET fecha_ahora = (SELECT CONCAT(v_anio,'-',v_mes,'-',v_dia));

	IF (v_tipo = 'sem') THEN
		SELECT u.id,p.name,p.last_name,p.fec_nac,u.position,j.name j_name,CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)) fec_birthday,DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) day_birthday FROM person p,user u,j_agroambiental j WHERE u.id_person=p.id AND u.cod_ja=j.cod_ja AND u.status LIKE 'activo' AND (DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) > -1 AND DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) < 8);
	ELSE
		IF (v_tipo = 'mes') THEN
			SELECT u.id,p.name,p.last_name,p.fec_nac,u.position,j.name j_name,CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)) fec_birthday,DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) day_birthday FROM person p,user u,j_agroambiental j WHERE u.id_person=p.id AND u.cod_ja=j.cod_ja AND u.status LIKE 'activo' AND SUBSTRING(p.fec_nac,6,2)=v_mes AND DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) > -1;
		END IF;
	END IF;

	IF (error = 1) THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END //

