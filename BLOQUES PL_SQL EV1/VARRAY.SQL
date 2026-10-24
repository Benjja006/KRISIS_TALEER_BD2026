/*
Como usuario de Krisis, quiero visualizar algunos géneros musicales disponibles para elegir qué música escuchar
Krisis debe permitir almacenar temporalmente hasta 5 géneros musicales en un VARRAY para mostrarlos al usuario.
*/

DECLARE 
    TYPE VR_GENEROS IS VARRAY(5) OF VARCHAR2(20);

    V_GENEROS VR_GENEROS := VR_GENEROS(
        'Rock',
        'Pop',
        'Reggaeton',
        'Trap',
        'Electronica'
    );
BEGIN
    DBMS_OUTPUT.PUT_LINE('---GENEROS MUSICALES DISPONIBLES---');
    DBMS_OUTPUT.PUT_LINE(V_GENEROS(1));
    DBMS_OUTPUT.PUT_LINE(V_GENEROS(7));
    DBMS_OUTPUT.PUT_LINE(V_GENEROS(3));
    DBMS_OUTPUT.PUT_LINE(V_GENEROS(4));
    DBMS_OUTPUT.PUT_LINE(V_GENEROS(6));


EXCEPTION
    WHEN SUBSCRIPT_OUTSIDE_LIMIT  THEN 
        DBMS_OUTPUT.PUT_LINE('Error, se trató de acceder a una posición inexistente');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DESCONOCIDO');
END;
/