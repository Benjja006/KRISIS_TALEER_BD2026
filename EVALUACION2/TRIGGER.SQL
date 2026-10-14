CREATE SEQUENCE stream_log_seq START WITH 100 INCREMENT BY 1;



CREATE OR REPLACE TRIGGER trg_stream_log_bi

BEFORE INSERT ON stream_log

FOR EACH ROW

DECLARE

  v_duracion cancion.duracion_segundos%TYPE;

BEGIN

  -- Autogenerar el ID si viene vacío

  IF :NEW.id_log IS NULL THEN

    :NEW.id_log := stream_log_seq.NEXTVAL;

  END IF;



  -- Autocompletar la fecha si viene vacía

  IF :NEW.fecha_hora IS NULL THEN

    :NEW.fecha_hora := SYSTIMESTAMP;

  END IF;



  -- Validar contra la duración de la canción

  SELECT duracion_segundos

   INTO v_duracion

   FROM cancion

   WHERE id_cancion = :NEW.id_cancion;



  IF :NEW.segundos_reproducidos > v_duracion THEN

    RAISE_APPLICATION_ERROR(-20001,

      'Los segundos reproducidos (' || :NEW.segundos_reproducidos ||

      ') superan la duración de la canción (' || v_duracion || ').');

  END IF;

END;

/

-- Funciona (la canción 20 dura 212 s); el id y la fecha se generan solos

INSERT INTO stream_log (id_usuario, id_cancion, segundos_reproducidos, id_pais)

VALUES (2, 20, 100, 2);

-- Falla con ORA-20001

INSERT INTO stream_log (id_usuario, id_cancion, segundos_reproducidos, id_pais)

VALUES (2, 20, 500, 2);

--creado por luis figueroa/subuido por benjamin sepulveda