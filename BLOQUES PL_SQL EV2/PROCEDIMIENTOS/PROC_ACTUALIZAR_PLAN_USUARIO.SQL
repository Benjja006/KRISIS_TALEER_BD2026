create or replace PROCEDURE pr_actualizar_plan_usuario (
    p_id_usuario IN NUMBER,
    p_es_premium IN CHAR
) IS
    e_usuario_no_encontrado EXCEPTION;
    e_valor_invalido        EXCEPTION;

    v_estado CHAR(1);
BEGIN
    -- 1. Normalizar el valor recibido.
    v_estado := TRIM(p_es_premium);

    -- 2. Validar el estado de la membresía.
    IF v_estado IS NULL OR v_estado NOT IN ('1', '0') THEN
        RAISE e_valor_invalido;
    END IF;

    -- 3. Actualizar la membresía del usuario.
    UPDATE usuario
       SET es_premium = v_estado
     WHERE id_usuario = p_id_usuario;

    -- 4. Verificar si existe el usuario.
    IF SQL%NOTFOUND THEN
        RAISE e_usuario_no_encontrado;
    END IF;

    DBMS_OUTPUT.PUT_LINE(
        'Plan del usuario ' || p_id_usuario ||
        ' actualizado con exito.'
    );

EXCEPTION
    WHEN e_valor_invalido THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'El parametro p_es_premium debe ser ''1'' o ''0''.'
        );

    WHEN e_usuario_no_encontrado THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'El usuario con ID ' || p_id_usuario || ' no existe.'
        );

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'Error inesperado en pr_actualizar_plan_usuario: ' ||
            SQLERRM
        );
END pr_actualizar_plan_usuario;
/

