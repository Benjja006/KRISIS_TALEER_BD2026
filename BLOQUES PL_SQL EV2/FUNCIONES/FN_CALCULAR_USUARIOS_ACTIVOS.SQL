CREATE OR REPLACE FUNCTION fn_porcentaje_usuarios_activos
RETURN NUMBER IS
    v_total_usuarios NUMBER := 0;
    v_activos_30d    NUMBER := 0;
    v_porcentaje     NUMBER := 0;

    -- Declaras tu excepción personalizada
    e_sin_usuarios EXCEPTION;
BEGIN
    -- 1. Obtener total de usuarios
    SELECT COUNT(*)
      INTO v_total_usuarios
      FROM usuario;

    -- Lanzar error si la tabla no tiene registros
    IF v_total_usuarios = 0 THEN
        RAISE e_sin_usuarios;
    END IF;

    -- 2. Obtener usuarios activos
    SELECT COUNT(DISTINCT id_usuario)
      INTO v_activos_30d
      FROM stream_log
     WHERE fecha_hora >= SYSDATE - 30;

    -- 3. Calcular porcentaje
    v_porcentaje := ROUND((v_activos_30d / v_total_usuarios) * 100, 2);

    RETURN v_porcentaje;

EXCEPTION
    -- Manejo del error personalizado cuando no hay usuarios
    WHEN e_sin_usuarios THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error funcional: No existen usuarios registrados en la base de datos.');

    -- Manejo de cualquier otro error inesperado (SQLERRM muestra el detalle del sistema)
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error interno en fn_porcentaje_usuarios_activos: ' || SQLERRM);
END fn_porcentaje_usuarios_activos;
/

SELECT fn_porcentaje_usuarios_activos() AS porcentaje_activos FROM dual;
