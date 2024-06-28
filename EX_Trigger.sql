CREATE OR REPLACE FUNCTION validar_anos()
RETURNS TRIGGER AS $BODY$
BEGIN
    IF NEW.inicio > NEW.fim THEN
        RAISE EXCEPTION 'O ano de início deve ser menor ou igual ao ano de fim.';
        RETURN NULL;
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER trig_validar_anos
BEFORE INSERT OR UPDATE ON dinossauros
FOR EACH ROW
EXECUTE FUNCTION validar_anos();


CREATE OR REPLACE FUNCTION validar_anos_era()
RETURNS TRIGGER AS $BODY$
DECLARE
    era_inicio INTEGER;
    era_fim INTEGER;
BEGIN
    SELECT ano_inicio, ano_fim INTO era_inicio, era_fim
    FROM eras
    WHERE id = NEW.fk_era;

    IF NEW.inicio > NEW.fim THEN
        RAISE EXCEPTION 'O ano de início deve ser menor ou igual ao ano de fim.';
        RETURN NULL;
    END IF;

    IF NEW.inicio < era_inicio OR NEW.fim > era_fim THEN
        RAISE EXCEPTION 'Os anos de existência do dinossauro não condizem com a era informada.';
        RETURN NULL;
    END IF;

    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER trig_validar_anos_era
BEFORE INSERT OR UPDATE ON dinossauros
FOR EACH ROW
EXECUTE FUNCTION validar_anos_era();
