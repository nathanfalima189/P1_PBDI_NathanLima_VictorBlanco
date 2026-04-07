-- Enunciado 1 - Base de dados e criação de tabela
-- A base a ser utilizada pode ser obtida a partir do link a seguir.
-- https://www.kaggle.com/datasets/yasserh/titanic-dataset
-- Ela deve ser importada para uma base de dados gerenciada pelo PostgreSQL. Os dados
-- devem ser armazenados em uma tabela apropriada para as análises desejadas. Você deve
-- identificar as colunas necessárias, de acordo com a descrição de cada item da prova.
-- Além, é claro, de uma chave primária (de auto incremento). Neste item, portanto, você
-- deve desenvolver o script de criação da tabela.
-- Mensagem de commit: feat(p1): cria base e importa dados

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