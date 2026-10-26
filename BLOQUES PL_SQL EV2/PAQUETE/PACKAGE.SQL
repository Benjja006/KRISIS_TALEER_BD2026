--Como administrador de KRISIS, quiero consultar información de los usuarios, verificar su actividad y gestionar sus planes gratuitos y premium,
--para mantener las cuentas actualizadas, controlar las suscripciones y obtener información útil sobre el uso de la plataforma.

-- 1. ESPECIFICACION PUBLICA DEL PAQUETE

CREATE OR REPLACE PACKAGE pkg_gestion_usuarios AS

    -- Actualizar el plan de un usuario
    PROCEDURE actualizar_plan(
        p_id_usuario IN NUMBER,
        p_es_premium IN CHAR
    );

    -- Mostrar reporte de usuarios premium y gratuitos
    PROCEDURE mostrar_reporte_planes;

    -- Consultar si un usuario es mayor de edad
    FUNCTION consultar_mayoria_edad(
        p_id_usuario IN NUMBER
    ) RETURN VARCHAR2;

    -- Consultar porcentaje de usuarios activos
    FUNCTION consultar_actividad RETURN NUMBER;

END pkg_gestion_usuarios;
/

-- 2. CUERPO DEL PAQUETE

CREATE OR REPLACE PACKAGE BODY pkg_gestion_usuarios AS

    -- Funcion privada: convierte el codigo del plan en una etiqueta
    FUNCTION obtener_etiqueta_plan(
        p_es_premium IN CHAR
    ) RETURN VARCHAR2 IS
    BEGIN
        IF TRIM(p_es_premium) = '1' THEN
            RETURN 'Premium';
        ELSIF TRIM(p_es_premium) = '0' THEN
            RETURN 'Gratuito';
        ELSE
            RETURN 'Desconocido';
        END IF;
    END obtener_etiqueta_plan;

    -- Procedimiento publico: actualiza el plan
    PROCEDURE actualizar_plan(
        p_id_usuario IN NUMBER,
        p_es_premium IN CHAR
    ) IS
    BEGIN
        pr_actualizar_plan_usuario(
            p_id_usuario,
            p_es_premium
        );

        DBMS_OUTPUT.PUT_LINE(
            'El usuario ' || p_id_usuario ||
            ' ahora tiene plan ' ||
            obtener_etiqueta_plan(p_es_premium) || '.'
        );
    END actualizar_plan;

    -- Procedimiento publico: muestra el reporte
    PROCEDURE mostrar_reporte_planes IS
    BEGIN
        sp_reporte_usuarios_premium;
    END mostrar_reporte_planes;

    -- Funcion publica: consulta la mayoria de edad
    FUNCTION consultar_mayoria_edad(
        p_id_usuario IN NUMBER
    ) RETURN VARCHAR2 IS
    BEGIN
        RETURN fn_es_usuario_adulto(p_id_usuario);
    END consultar_mayoria_edad;

    -- Funcion publica: consulta la actividad
    FUNCTION consultar_actividad RETURN NUMBER IS
    BEGIN
        RETURN fn_porcentaje_usuarios_activos;
    END consultar_actividad;

END pkg_gestion_usuarios;
/


