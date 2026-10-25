--bloque de funciones 
CREATE OR REPLACE FUNCTION fn_es_usuario_adulto (
    p_id_usuario IN NUMBER
) RETURN VARCHAR2 IS
    v_fecha_nac DATE;
    v_edad      NUMBER;
BEGIN
    --Buscamos la fecha de nacimiento del usuario
    SELECT fecha_nacimiento
      INTO v_fecha_nac
      FROM usuario
     WHERE id_usuario = p_id_usuario;

    --Si no tiene registrada la fecha de nacimiento
    IF v_fecha_nac IS NULL THEN
        RETURN 'N';
    END IF;

    --Calculamos la edad actual en años
    v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_nac) / 12);

    --Verificamos si es mayor de edad
    IF v_edad >= 18 THEN
        RETURN 'S';
    ELSE
        RETURN 'N';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        --Si el ID de usuario no existe
        RETURN 'N';
END fn_es_usuario_adulto;
/
