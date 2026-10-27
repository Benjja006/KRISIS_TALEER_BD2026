--Como administrador de  KRISIS,
--quiero gestionar los planes gratuitos y premium de los usuarios, 
--consultar su mayoría de edad y su actividad en la plataforma, 
--generar reportes de membresías, normalizar los datos personales y 
--proteger el historial de reproducciones, para mantener la información de las cuentas consistente, 
--controlar las suscripciones y obtener información útil sobre el uso de la plataforma.

DECLARE

    v_id_usuario NUMBER;
    v_nombre     VARCHAR2(100);
    v_email      VARCHAR2(100);
    v_plan       CHAR(1);
    v_mayoria    VARCHAR2(1);
    v_actividad  NUMBER;
    v_error      NUMBER;


BEGIN
    
    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE(' PRUEBAS DE INTEGRACION KRISIS');
    DBMS_OUTPUT.PUT_LINE(' Historia de usuario: gestion de cuentas');
    DBMS_OUTPUT.PUT_LINE('================================');

    --------------------------------------------------
    -- 1. INSERTAR USUARIO Y PROBAR TRIGGER DE FILA
    --------------------------------------------------
    SELECT NVL(MAX(id_usuario), 0) + 1
      INTO v_id_usuario
      FROM usuario;

    INSERT INTO usuario (
        id_usuario,
        nombre_usuario,
        email,
        password,
        fecha_nacimiento,
        fecha_registro,
        pais_id_pais,
        es_premium,
        cosmetico_id
    ) VALUES (
        v_id_usuario,
        '  Prueba KRISIS  ',
        '  PRUEBA.KRISIS.' || v_id_usuario || '@EXAMPLE.COM ',
        'hashed_pass_prueba',
        TO_DATE('2000-05-15', 'YYYY-MM-DD'),
        SYSTIMESTAMP,
        1,
        '0',
        NULL
    );

    SELECT nombre_usuario, email
    INTO v_nombre, v_email
    FROM usuario
    WHERE id_usuario = v_id_usuario;

    IF v_nombre = 'prueba krisis'
       AND v_email =
           'prueba.krisis.' || v_id_usuario || '@example.com'
    THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] Trigger de fila: datos normalizados.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[ERROR] Trigger de fila: revisar datos.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        'Usuario de prueba: ' || v_id_usuario
    );

    --------------------------------------------------
    -- 2. PROCEDIMIENTO CON PARAMETROS
    --------------------------------------------------
    pr_actualizar_plan_usuario(v_id_usuario, '1');

    SELECT es_premium
      INTO v_plan
      FROM usuario
     WHERE id_usuario = v_id_usuario;

    IF v_plan = '1' THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] Procedimiento: plan premium actualizado.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[ERROR] Procedimiento: plan incorrecto.'
        );
    END IF;

    --------------------------------------------------
    -- 3. VALIDAR PARAMETRO INVALIDO
    --------------------------------------------------
    BEGIN
        pr_actualizar_plan_usuario(v_id_usuario, 'X');

        DBMS_OUTPUT.PUT_LINE(
            '[ERROR] Se acepto un plan invalido.'
        );

    EXCEPTION
        WHEN OTHERS THEN
            v_error := SQLCODE;

            IF v_error = -20003 THEN
                DBMS_OUTPUT.PUT_LINE(
                    '[OK] Procedimiento: plan invalido rechazado.'
                );
            ELSE
                DBMS_OUTPUT.PUT_LINE(
                    '[ERROR] Codigo inesperado: ' || v_error
                );
            END IF;
    END;

    --------------------------------------------------
    -- 4. FUNCION CON PARAMETROS
    --------------------------------------------------
    v_mayoria := fn_es_usuario_adulto(v_id_usuario);

    IF v_mayoria = 'S' THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] Funcion: usuario mayor de edad.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[ERROR] Funcion: resultado inesperado.'
        );
    END IF;

    --------------------------------------------------
    -- 5. FUNCION SIN PARAMETROS
    --------------------------------------------------
    v_actividad := fn_porcentaje_usuarios_activos;

    DBMS_OUTPUT.PUT_LINE(
        'Porcentaje de usuarios activos: ' ||
        v_actividad || '%'
    );

    --------------------------------------------------
    -- 6. PACKAGE: ACTUALIZAR PLAN
    --------------------------------------------------
    pkg_gestion_usuarios.actualizar_plan(
        v_id_usuario,
        '0'
    );

    SELECT es_premium
    INTO v_plan
    FROM usuario
    WHERE id_usuario = v_id_usuario;

    IF v_plan = '0' THEN
        DBMS_OUTPUT.PUT_LINE(
            '[OK] Package: plan gratuito actualizado.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '[ERROR] Package: plan incorrecto.'
        );
    END IF;

    --------------------------------------------------
    -- 7. PACKAGE: REPORTE Y FUNCIONES
    --------------------------------------------------
    pkg_gestion_usuarios.mostrar_reporte_planes;

    v_mayoria :=
        pkg_gestion_usuarios.consultar_mayoria_edad(
            v_id_usuario
        );

    DBMS_OUTPUT.PUT_LINE(
        'Mayor de edad mediante package: ' || v_mayoria
    );

    v_actividad :=
        pkg_gestion_usuarios.consultar_actividad;

    DBMS_OUTPUT.PUT_LINE(
        'Actividad mediante package: ' ||
        v_actividad || '%'
    );

    --------------------------------------------------
    -- 8. PROCEDIMIENTO SIN PARAMETROS
    --------------------------------------------------
    sp_reporte_usuarios_premium;

    --------------------------------------------------
    -- 9. TRIGGER DE SENTENCIA: PROTEGER HISTORIAL
    --------------------------------------------------
    BEGIN
        DELETE FROM stream_log
         WHERE id_log = -999999;

        DBMS_OUTPUT.PUT_LINE(
            '[ERROR] El trigger permitio el DELETE.'
        );
    
    EXCEPTION
        WHEN OTHERS THEN
            v_error := SQLCODE;

            IF v_error = -20016 THEN
                DBMS_OUTPUT.PUT_LINE(
                    '[OK] Trigger de sentencia: DELETE bloqueado.'
                );
            ELSE
                DBMS_OUTPUT.PUT_LINE(
                    '[ERROR] Codigo inesperado: ' || v_error
                );
            END IF;
    END;

    --------------------------------------------------
    -- 10. CONFIRMAR CAMBIOS
    --------------------------------------------------
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE(' FIN DE LAS PRUEBAS');
    DBMS_OUTPUT.PUT_LINE(' Cambios confirmados con COMMIT.');
    DBMS_OUTPUT.PUT_LINE('================================');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'ERROR GENERAL: ' || SQLERRM
        );
        DBMS_OUTPUT.PUT_LINE(
            'No se ejecuto COMMIT en el bloque principal.'
        );
END;
/