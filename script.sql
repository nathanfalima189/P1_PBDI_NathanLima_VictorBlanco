CREATE TABLE p1titanic(
    PassengerId INT PRIMARY KEY,
    Survived INT,
    Pclass INT,
    Name TEXT,
    Sex VARCHAR(10),
    Age NUMERIC,
    SibSp INT,
    Parch INT,
    Ticket TEXT,
    Fare FLOAT,
    Cabin TEXT,
    Embarked VARCHAR(5)
);

SELECT * FROM p1titanic;

ALTER TABLE p1titanic

DROP COLUMN Name,

DROP COLUMN Age,

DROP COLUMN SibSp,

DROP COLUMN Parch,

DROP COLUMN Ticket,

DROP COLUMN Cabin;

-- Enunciado 2 - Sobrevivência em função da classe social 
-- Escreva um cursor não vinculado que mostra o número de passageiros sobreviventes que 
-- viajavam na primeira classe (Pclass = 1). 
-- Mensagem de commit: feat(p1): encontra sobreviventes da primeira classe

DO $$
DECLARE
    cur_sobreviventes REFCURSOR;
    v_survived INT;
    v_tot_sobreviventes INT := 0;
BEGIN
    OPEN cur_sobreviventes FOR EXECUTE
    format
    (
        '
        SELECT survived
         FROM p1_titanic
         WHERE pclass = 1
           AND survived = 1;
           '
    );
    LOOP
        FETCH cur_sobreviventes INTO v_survived;
        EXIT WHEN NOT FOUND;
        v_tot_sobreviventes := v_tot_sobreviventes + 1;
    END LOOP;
    CLOSE cur_sobreviventes;
    RAISE NOTICE 
        'O número de passageiros que sobreviveram na 1ª classe é %', 
        v_tot_sobreviventes;
END;
$$;

-- Enunciado 3 -  Sobrevivência em função do gênero 
-- Escreva um cursor com query dinâmica que mostra o número de passageiros 
-- sobreviventes dentre as mulheres (Sex = 'female'). Escreva um condicional para que, se 
-- não existir nenhuma, o valor -1 seja exibido. 
-- Mensagem de commit: feat(p1): encontra sobreviventes do sexo feminino 

DO $$
DECLARE
    ref refcursor;
    v_survived INTEGER;
    v_total INTEGER := 0;
BEGIN
    OPEN ref FOR EXECUTE
    format
    (
        '
        SELECT survived
         FROM p1_titanic
         WHERE sex = 'female'
           AND survived = 1
           '
    );
    LOOP
        FETCH ref INTO v_survived;
        EXIT WHEN NOT FOUND;

        v_total := v_total + 1;
    END LOOP;
    CLOSE ref;
    IF v_total = 0 THEN
        RAISE NOTICE 'Resultado: %', -1;
    ELSE
        RAISE NOTICE 'Mulheres sobreviventes: %', v_total;
    END IF;
END $$;

-- Enunciado 4 -  Tarifa versus embarque 
-- Dentre os passageiros que pagaram tarifa (Fare) maior que 50, quantos embarcaram em 
-- Cherbourg (Embarked = 'C')? Escreva um cursor vinculado que exiba esse valor. 
-- Mensagem de commit: feat(p1): encontra passageiros de Cherbourg com tarifa alta

DO $$
DECLARE
    -- Cursor vinculado (explícito)
    CURSOR cur_cherbourg_fare_alta IS
        SELECT passengerid
        FROM p1_titanic
        WHERE fare > 50
          AND embarked = 'C';

    v_passengerid INTEGER;
    v_total INTEGER := 0;
BEGIN
    OPEN cur_cherbourg_fare_alta;

    LOOP
        FETCH cur_cherbourg_fare_alta INTO v_passengerid;
        EXIT WHEN NOT FOUND;

        v_total := v_total + 1;
    END LOOP;

    CLOSE cur_cherbourg_fare_alta;

    RAISE NOTICE
        'Número de passageiros embarcados em Cherbourg e com tarifa > 50: %',
        v_total;
END $$;

-- Enunciado 5  Limpeza de valores NULL 
-- Escreva um cursor não vinculado para a remoção de todas as tuplas que possuam o valor 
-- NULL em pelo menos um de seus campos. Antes de fazer a sua remoção, exiba a tupla. A 
-- seguir, mostre as tuplas remanescentes, de baixo para cima. 
-- Mensagem de commit: feat(p1): remove com dados faltantes

DO $$
DECLARE
    ref refcursor;
    ref_scroll refcursor;
    v_passengerid INTEGER;
    v_survived INTEGER;
    v_pclass INTEGER;
    v_name TEXT;
    v_sex TEXT;
    v_age NUMERIC;
    v_fare NUMERIC;
    v_embarked TEXT;
BEGIN
    OPEN ref FOR EXECUTE
    format
    (
        '
        SELECT passengerid, survived, pclass, name, sex, age, fare, embarked
        FROM tb_titanic
        WHERE passengerid IS NULL
           OR survived IS NULL
           OR pclass IS NULL
           OR name IS NULL
           OR sex IS NULL
           OR age IS NULL
           OR fare IS NULL
           OR embarked IS NULL
        '
    );
    LOOP
        FETCH ref
        INTO v_passengerid, v_survived, v_pclass,
             v_name, v_sex, v_age, v_fare, v_embarked;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE
            'Tuplas removidas -> ID: %, Nome: %, Sexo: %, Idade: %, Tarifa: %, Embarque: %',
            v_passengerid, v_name, v_sex, v_age, v_fare, v_embarked;
        DELETE FROM tb_titanic
        WHERE passengerid = v_passengerid;
    END LOOP;
    CLOSE ref;
    OPEN ref_scroll SCROLL FOR
        SELECT passengerid, survived, pclass, name, sex, age, fare, embarked
        FROM tb_titanic
        ORDER BY passengerid;
    FETCH LAST FROM ref_scroll
    INTO v_passengerid, v_survived, v_pclass,
         v_name, v_sex, v_age, v_fare, v_embarked;
    WHILE FOUND LOOP
        RAISE NOTICE
            'Tuplas que restaram -> ID: %, Nome: %, Sexo: %, Idade: %, Tarifa: %, Embarque: %',
            v_passengerid, v_name, v_sex, v_age, v_fare, v_embarked;
        FETCH PRIOR FROM ref_scroll
        INTO v_passengerid, v_survived, v_pclass,
             v_name, v_sex, v_age, v_fare, v_embarked;
    END LOOP;
    CLOSE ref_scroll;
END $$;