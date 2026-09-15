/*Como usuario de Krisis, quiero consultar las canciones que he escuchado para conocer mi historial de reproducción.
 Krisis debe permitir consultar las canciones reproducidas por un usuario, mostrando el título de la canción y los segundos reproducidos.*/
SET serveroutput ON;
DECLARE 
    CURSOR C_HISTORIAL IS 
    SELECT C.TITULO AS CANCION,
    A.NOMBRE_ARTISTICO AS ARTISTA,
    P.NOMBRE AS PAIS,
    S.SEGUNDOS_REPRODUCIDOS,
    S.FECHA_HORA
    FROM STREAM_LOG S 
    JOIN CANCION C ON C.ID_CANCION = S.ID_CANCION
    JOIN CANCION_ARTISTA CA ON CA.CANCION_ID_CANCION = C.ID_CANCION
    JOIN ARTISTA A ON A.ID_ARTISTA = CA.ARTISTA_ID_ARTISTA
    JOIN PAIS P ON P.ID_PAIS = S.ID_PAIS
    WHERE S.ID_USUARIO = 1
    ORDER BY S.FECHA_HORA DESC;

BEGIN 
    FOR REGISTRO IN C_HISTORIAL LOOP 
        DBMS_OUTPUT.PUT_LINE('CANCION: '||REGISTRO.CANCION);
        DBMS_OUTPUT.PUT_LINE('ARTISTA: '||REGISTRO.ARTISTA);
        DBMS_OUTPUT.PUT_LINE('PAIS: '||REGISTRO.PAIS);
        DBMS_OUTPUT.PUT_LINE('SEGUNDOS DE REPRODUCIDOS: '||REGISTRO.SEGUNDOS_REPRODUCIDOS);
        DBMS_OUTPUT.PUT_LINE('FECHA: '||REGISTRO.FECHA_HORA);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SE PRODUJO UN ERROR: ');
END;

/
