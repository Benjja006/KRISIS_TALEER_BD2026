--Calcula la cantidad de usuarios premium y no premium actualmente en krisis
CREATE OR REPLACE PROCEDURE sp_reporte_usuarios_premium
IS
    v_total_usuarios  NUMBER := 0;
    v_usuarios_premium NUMBER := 0;
    v_usuarios_gratis  NUMBER := 0;
    v_porcentaje_premium NUMBER := 0;
    v_porcentaje_gratis  NUMBER := 0;

BEGIN
    -- Contar usuarios según su tipo de membresía.
    SELECT COUNT(*),
           NVL(SUM(CASE
                       WHEN es_premium = '1' THEN 1
                       ELSE 0
                   END), 0),
           NVL(SUM(CASE
                       WHEN es_premium = '0' THEN 1
                       ELSE 0
                   END), 0)
      INTO v_total_usuarios,
           v_usuarios_premium,
           v_usuarios_gratis
      FROM usuario;

    -- Calcular porcentajes evitando división por cero.
    IF v_total_usuarios > 0 THEN
        v_porcentaje_premium :=
            ROUND(v_usuarios_premium * 100 / v_total_usuarios, 2);

        v_porcentaje_gratis :=
            ROUND(v_usuarios_gratis * 100 / v_total_usuarios, 2);
    END IF;

    -- Mostrar el reporte.
    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE(' REPORTE DE MEMBRESIAS - KRISIS');
    DBMS_OUTPUT.PUT_LINE('================================');
    DBMS_OUTPUT.PUT_LINE(
        'Total de usuarios: ' || v_total_usuarios
    );
    DBMS_OUTPUT.PUT_LINE(
        'Usuarios premium: ' || v_usuarios_premium
    );
    DBMS_OUTPUT.PUT_LINE(
        'Usuarios gratuitos: ' || v_usuarios_gratis
    );
    DBMS_OUTPUT.PUT_LINE(
        'Porcentaje premium: ' || v_porcentaje_premium || '%'
    );
    DBMS_OUTPUT.PUT_LINE(
        'Porcentaje gratuitos: ' || v_porcentaje_gratis || '%'
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Error al generar el reporte de membresias: ' || SQLERRM
        );
END sp_reporte_usuarios_premium;
/
