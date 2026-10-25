CREATE OR REPLACE PROCEDURE pr_actualizar_plan_usuario (
    p_id_usuario IN NUMBER,
    p_es_premium IN CHAR
) IS
    e_usuario_no_encontrado EXCEPTION;
    e_valor_invalido        EXCEPTION;
    
    v_estado CHAR(1);
BEGIN
    v_estado := TRIM(p_es_premium);

    -- 1. Validar que el parámetro p_es_premium sea 'S' o 'N' (o 'Y'/'N' según tu modelo)
    IF v_estado NOT IN (1, 0) OR v_estado IS NULL THEN
        RAISE e_valor_invalido;
    END IF;

    -- 2. Ejecutar la actualización
    UPDATE usuario
       SET es_premium = v_estado
     WHERE id_usuario = p_id_usuario;

    -- 3. Validar si afectó alguna fila
    IF SQL%NOTFOUND THEN
        RAISE e_usuario_no_encontrado;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Plan del usuario ' || p_id_usuario || ' actualizado con éxito.');

EXCEPTION
    WHEN e_valor_invalido THEN
        RAISE_APPLICATION_ERROR(-20003, 'El parámetro p_es_premium debe ser ''1'' o ''0''.');

    WHEN e_usuario_no_encontrado THEN
        RAISE_APPLICATION_ERROR(-20004, 'El usuario con ID ' || p_id_usuario || ' no existe.');

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005, 'Error inesperado en pr_actualizar_plan_usuario: ' || SQLERRM);
END pr_actualizar_plan_usuario;
/

EXEC PR_ACTUALIZAR_PLAN_USUARIO (1, 5);
COMMIT;