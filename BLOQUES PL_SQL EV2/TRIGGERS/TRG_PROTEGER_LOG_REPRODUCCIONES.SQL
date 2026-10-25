CREATE OR REPLACE TRIGGER trg_proteger_historial_stream
BEFORE DELETE ON STREAM_LOG
BEGIN
    RAISE_APPLICATION_ERROR(
        -20016,
        'Operacion no permitida: no se pueden eliminar registros del historial de reproducciones.'
    );
END;
/
