-- ============================================================
-- TRIGGER: normaliza nombre_usuario y email de la tabla USUARIO
-- ============================================================
CREATE OR REPLACE TRIGGER trg_limpiar_datos_usuario
BEFORE INSERT OR UPDATE ON usuario
FOR EACH ROW
BEGIN
    -- Nombre de usuario: sin espacios en los extremos y todo en minúscula
    :NEW.nombre_usuario := LOWER(TRIM(:NEW.nombre_usuario));

    -- Email: sin ningún espacio y todo en minúscula
    :NEW.email := LOWER(REPLACE(:NEW.email, ' ', ''));
END trg_limpiar_datos_usuario;
/