--1. Cria��o do DB e tabelas:

-- Cria��o do banco de dados
CREATE DATABASE CashFlowDB;
USE CashFlowDB;

-- Tabela de Contas
CREATE TABLE Accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID incremental para identifica��o �nica
    account_name VARCHAR(50) NOT NULL,        -- Nome da conta, obrigat�rio
    account_type VARCHAR(20) NOT NULL,        -- Tipo da conta (ex.: corrente, poupan�a)
    initial_balance FLOAT NOT NULL            -- Saldo inicial da conta
);

-- Tabela de Categorias
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID incremental para identifica��o �nica
    category_name VARCHAR(50) NOT NULL,        -- Nome da categoria, obrigat�rio
    category_type VARCHAR(10) NOT NULL         -- Tipo da categoria (ex.: receita, despesa)
);

-- Tabela de Centros de Custo
CREATE TABLE CostCenters (
    cost_center_id INT IDENTITY(1,1) PRIMARY KEY, -- ID incremental para identifica��o �nica
    cost_center_name VARCHAR(50) NOT NULL,       -- Nome do centro de custo, obrigat�rio
    description VARCHAR(200)                     -- Descri��o opcional
);

-- Tabela de Formas de Pagamento
CREATE TABLE PaymentMethods (
    payment_method_id INT IDENTITY(1,1) PRIMARY KEY, -- ID incremental para identifica��o �nica
    payment_type VARCHAR(20) NOT NULL               -- Tipo de pagamento (ex.: cr�dito, d�bito)
);

-- Tabela de Movimenta��es Financeiras
CREATE TABLE FinancialMovements (
    movement_id INT IDENTITY(1,1) PRIMARY KEY,       -- ID incremental para identifica��o �nica
    movement_date DATE NOT NULL,                     -- Data da movimenta��o, obrigat�rio
    amount DECIMAL(12, 2) NOT NULL,                  -- Valor da movimenta��o
    description VARCHAR(200),                        -- Descri��o opcional
    account_id INT NOT NULL,                         -- ID da conta relacionada
    category_id INT NOT NULL,                        -- ID da categoria relacionada
    cost_center_id INT,                              -- ID do centro de custo (opcional)
    payment_method_id INT NOT NULL,                  -- ID da forma de pagamento relacionada
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),           -- Chave estrangeira para tabela de contas
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),       -- Chave estrangeira para tabela de categorias
    FOREIGN KEY (cost_center_id) REFERENCES CostCenters(cost_center_id),-- Chave estrangeira para tabela de centros de custo
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods(payment_method_id) -- Chave estrangeira para tabela de formas de pagamento
);

--2. Cria��o de �ndices e facilitadores:

-- �ndice para facilitar buscas por account_id na tabela FinancialMovements
CREATE INDEX IDX_FinancialMovements_AccountID ON FinancialMovements(account_id);

-- �ndice para facilitar buscas por category_id na tabela FinancialMovements
CREATE INDEX IDX_FinancialMovements_CategoryID ON FinancialMovements(category_id);

-- �ndice para facilitar buscas por movement_date na tabela FinancialMovements
CREATE INDEX IDX_FinancialMovements_MovementDate ON FinancialMovements(movement_date);

-- �ndices adicionais para otimizar consultas espec�ficas
CREATE INDEX IDX_FinancialMovements_PaymentMethodID ON FinancialMovements(payment_method_id); -- Busca por formas de pagamento
CREATE INDEX IDX_FinancialMovements_CostCenterID ON FinancialMovements(cost_center_id);       -- Busca por centros de custo

-- Adiciona valor padr�o para movement_date, preenchendo automaticamente a data atual caso n�o especificado
ALTER TABLE FinancialMovements 
ADD DEFAULT GETDATE() FOR movement_date;



--3. Popula��o de tabelas para valida��o:

-- Inser��o de dados na tabela Accounts, representando diferentes tipos de contas
INSERT INTO Accounts (account_name, account_type, initial_balance)
VALUES
('Conta Corrente', 'C', 5000.00),          -- Conta corrente com saldo inicial
('Poupan�a', 'P', 10000.00),              -- Conta poupan�a com saldo inicial
('Conta de Investimentos', 'I', 20000.00); -- Conta de investimentos com saldo inicial

-- Inser��o de dados na tabela Categories, incluindo receitas e despesas
INSERT INTO Categories (category_name, category_type)
VALUES 
('Sal�rio', 'R'),                        -- Receita: Sal�rio
('Aluguel', 'D'),                        -- Despesa: Aluguel
('Compra de Equipamentos', 'D'),         -- Despesa: Compra de equipamentos
('Venda de Produto', 'R'),               -- Receita: Venda de produto
('Compra de Materiais', 'D');            -- Despesa: Compra de materiais

-- Inser��o de dados na tabela CostCenters, representando centros de custo da empresa
INSERT INTO CostCenters (cost_center_name, description)
VALUES 
('Administra��o', 'Despesas administrativas gerais'), -- Centro de custo para administra��o
('TI', 'Tecnologia da Informa��o'),                  -- Centro de custo para TI
('Marketing', 'Promo��o e publicidade');             -- Centro de custo para marketing

-- Inser��o de dados na tabela PaymentMethods, representando formas de pagamento
INSERT INTO PaymentMethods (payment_type)
VALUES 
('Dinheiro'),                  -- Pagamento em dinheiro
('Cart�o de Cr�dito'),         -- Pagamento com cart�o de cr�dito
('Transfer�ncia');             -- Pagamento por transfer�ncia banc�ria


-- Inser��o de dados na tabela FinancialMovements, exemplificando movimenta��es financeiras
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2024-12-01', 5000.00, 'Sal�rio recebido', 1, 1, NULL, 1),             -- Receita de sal�rio
('2024-12-02', -1500.00, 'Pagamento de aluguel', 1, 2, 1, 2),          -- Despesa com aluguel
('2024-12-03', 2000.00, 'Venda de Produto A', 2, 4, 2, 1),             -- Receita de venda de produto
('2024-12-04', -500.00, 'Compra de Material de Escrit�rio', 1, 5, 3, 3); -- Despesa com compra de materiais

-- December 2024
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2024-12-15', 3000.00, 'Bonus recebido', 1, 1, NULL, 1),
('2024-12-20', -800.00, 'Manuten��o do escrit�rio', 1, 5, 3, 3);

-- January 2025
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2025-01-05', -2000.00, 'Pagamento de fornecedor', 2, 2, 1, 2),
('2025-01-10', 4000.00, 'Recebimento de projeto', 2, 4, 2, 1);

-- February 2025
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2025-02-01', 1000.00, 'Reembolso de despesas', 1, 1, 1, 3),
('2025-02-15', -500.00, 'Compra de materiais', 1, 5, 3, 3);

-- March 2025
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2025-03-10', -1200.00, 'Pagamento de consultoria', 2, 2, 1, 2),
('2025-03-25', 2500.00, 'Venda de servi�o', 1, 4, 2, 1);

-- April 2025
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2025-04-05', -700.00, 'Despesas de viagem', 1, 5, 3, 3),
('2025-04-15', 3000.00, 'Recebimento de projeto B', 2, 4, 2, 1);

-- May 2025
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2025-05-01', 1500.00, 'Recebimento de contrato', 1, 1, 1, 3),
('2025-05-20', -600.00, 'Despesas operacionais', 1, 2, 3, 2);


--4. Cria��o de Stored Procedures:

-- Stored Procedure: C�lculo do Saldo do Fluxo de Caixa
CREATE PROCEDURE GetCashFlowBalance
AS
BEGIN
    SELECT 
        a.account_id,  -- ID da conta
        a.account_name, -- Nome da conta
        SUM(CASE WHEN c.category_type = 'R' THEN f.amount ELSE -f.amount END) AS current_balance -- Saldo atual calculado
    FROM 
        Accounts a
    LEFT JOIN FinancialMovements f ON a.account_id = f.account_id -- Relaciona contas �s movimenta��es financeiras
    LEFT JOIN Categories c ON f.category_id = c.category_id       -- Relaciona movimenta��es �s categorias
    GROUP BY a.account_id, a.account_name; -- Agrupa por conta para consolidar os saldos
END;

-- Executa a stored procedure para calcular o saldo do fluxo de caixa
EXEC GetCashFlowBalance;



-- Stored Procedure: Gera��o de Relat�rios de Receitas e Despesas
CREATE PROCEDURE GetIncomeExpenseReport
AS
BEGIN
    SELECT 
        c.category_type, -- Tipo da categoria (Receita ou Despesa)
        c.category_name, -- Nome da categoria
        SUM(f.amount) AS total_amount -- Total acumulado por categoria
    FROM 
        FinancialMovements f
    JOIN Categories c ON f.category_id = c.category_id -- Relaciona movimenta��es �s categorias
    GROUP BY c.category_type, c.category_name; -- Agrupa por tipo e nome da categoria
END;

-- Executa a stored procedure para gerar o relat�rio de receitas e despesas
EXEC GetIncomeExpenseReport;



-- Stored Procedure: Proje��o de Fluxo de Caixa Futuro
CREATE PROCEDURE GetCashFlowProjection (@months INT)
AS
BEGIN
    -- Cria uma tabela tempor�ria de n�meros para proje��o mensal
    WITH Numbers AS (
        SELECT TOP (@months) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS number
        FROM master.dbo.spt_values -- Tabela do sistema usada para gerar uma sequ�ncia de n�meros
    )
    SELECT 
        DATEADD(MONTH, n.number - 1, GETDATE()) AS projected_month, -- M�s projetado
        SUM(CASE WHEN c.category_type = 'R' THEN f.amount ELSE -f.amount END) AS projected_balance -- Saldo projetado
    FROM 
        FinancialMovements f
    JOIN Categories c ON f.category_id = c.category_id -- Relaciona movimenta��es �s categorias
    CROSS JOIN Numbers n -- Combina cada m�s projetado com os dados financeiros
    WHERE 
        f.movement_date BETWEEN DATEADD(MONTH, n.number - 1, GETDATE()) AND DATEADD(MONTH, n.number, GETDATE()) -- Movimenta��es no intervalo do m�s
    GROUP BY n.number -- Agrupa por m�s projetado
    ORDER BY projected_month; -- Ordena os resultados por m�s
END;

-- Executa a stored procedure para calcular a proje��o do fluxo de caixa para os pr�ximos 6 meses
EXEC GetCashFlowProjection @months = 6;



-- Placeholder para TIR (Taxa Interna de Retorno)
-- A cria��o do tipo "CashFlowTable" inicia a estrutura para opera��es financeiras avan�adas
CREATE TYPE CashFlowTable AS TABLE (
    period INT,           -- Per�odo de tempo do fluxo de caixa
    value DECIMAL(18, 2)  -- Valor associado ao per�odo
);



-- Stored Procedure para o c�lculo aproximado da Taxa Interna de Retorno (TIR)
CREATE PROCEDURE CalculateIRR
(
    @cashFlows CashFlowTable READONLY, -- Par�metro tabela para fluxos de caixa, somente leitura
    @initialGuess DECIMAL(5, 4),       -- Chute inicial para o c�lculo da TIR
    @irrResult DECIMAL(5, 4) OUTPUT    -- Par�metro de sa�da para armazenar o resultado da TIR
)
AS
BEGIN
    -- Declara��o de vari�veis internas
    DECLARE @rate DECIMAL(5, 4) = @initialGuess; -- Taxa inicial de desconto
    DECLARE @tolerance DECIMAL(5, 4) = 0.0001;   -- Toler�ncia para o erro no c�lculo
    DECLARE @maxIterations INT = 1000;          -- N�mero m�ximo de itera��es permitidas
    DECLARE @iteration INT = 0;                 -- Contador de itera��es
    DECLARE @npv DECIMAL(18, 4);                -- Valor Presente L�quido (NPV)
    DECLARE @derivative DECIMAL(18, 4);         -- Derivada da fun��o NPV para o m�todo de Newton-Raphson

    -- Loop de c�lculo usando o m�todo de Newton-Raphson
    WHILE @iteration < @maxIterations
    BEGIN
        -- Inicializa NPV e derivada para cada itera��o
        SET @npv = 0;
        SET @derivative = 0;

        -- Calcula o NPV e sua derivada com base nos fluxos de caixa
        SELECT 
            @npv = @npv + (value / POWER(1 + @rate, period)),       -- Soma do valor descontado
            @derivative = @derivative - (period * value / POWER(1 + @rate, period + 1)) -- Derivada parcial
        FROM @cashFlows;

        -- Verifica se o NPV est� pr�ximo de zero
        IF ABS(@npv) < @tolerance
            BREAK;

        -- Atualiza a taxa de desconto usando o m�todo de Newton-Raphson
        SET @rate = @rate - (@npv / @derivative);

        -- Incrementa o contador de itera��es
        SET @iteration = @iteration + 1;
    END;

    -- Define o resultado final da TIR
    SET @irrResult = @rate;
END;


-- Exemplo de uso da Stored Procedure para calcular a TIR(Executar as linhas abaixo em conjunto)

--1. Declara��o de uma vari�vel tabela para fluxos de caixa
DECLARE @cashFlows CashFlowTable;

--2. Inser��o de dados de exemplo de fluxo de caixa
INSERT INTO @cashFlows (period, value)
VALUES (0, -1000), (1, 500), (2, 600), (3, 700); -- Fluxo de caixa t�pico com valores para diferentes per�odos

--3. Declara��o de uma vari�vel para capturar o resultado da TIR
DECLARE @irrResult DECIMAL(5, 4);

--4. Execu��o da stored procedure com os fluxos de caixa e o chute inicial
EXEC CalculateIRR @cashFlows = @cashFlows, @initialGuess = 0.1, @irrResult = @irrResult OUTPUT;

--5. Exibi��o do resultado da TIR
SELECT @irrResult AS 'Taxa Interna de Retorno (TIR)'; -- Resultado final para an�lise




-- 5. Cria��o de Fun��es �teis

-- Fun��o para C�lculo de Juros Compostos
CREATE FUNCTION CalculateCompoundInterest
(
    @principal DECIMAL(18, 2), -- Valor presente (PV)
    @rate DECIMAL(5, 4),       -- Taxa de juros (r)
    @time INT                  -- N�mero de per�odos (n)
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    RETURN @principal * POWER(1 + @rate, @time); -- F�rmula de juros compostos
END;

-- Exemplo de Uso: Calcula o valor futuro com base nos par�metros fornecidos
SELECT dbo.CalculateCompoundInterest(1000, 0.05, 12) AS ValorFuturo;


-- Fun��o para C�lculo do Valor Presente L�quido (VPL)
CREATE FUNCTION CalculateNPV
(
    @rate DECIMAL(5, 4),       -- Taxa de desconto
    @cashFlows NVARCHAR(MAX)   -- Fluxos de caixa no formato: "1,500;2,600;3,700"
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    -- Declara��o de vari�veis para processamento
    DECLARE @npv DECIMAL(18, 2) = 0; -- Valor Presente L�quido acumulado
    DECLARE @index INT = 1;          -- �ndice de controle
    DECLARE @item NVARCHAR(100);     -- Item atual extra�do da string
    DECLARE @period INT;             -- Per�odo extra�do do item
    DECLARE @value DECIMAL(18, 2);   -- Valor extra�do do item

    -- Processamento da string delimitada para calcular o VPL
    WHILE CHARINDEX(';', @cashFlows) > 0 OR LEN(@cashFlows) > 0
    BEGIN
        -- Extra��o do item atual (per�odo e valor)
        SET @item = CASE 
                       WHEN CHARINDEX(';', @cashFlows) > 0 
                       THEN LEFT(@cashFlows, CHARINDEX(';', @cashFlows) - 1)
                       ELSE @cashFlows
                   END;

        -- Separa��o do per�odo e valor a partir do item
        SET @period = CONVERT(INT, LEFT(@item, CHARINDEX(',', @item) - 1));
        SET @value = CONVERT(DECIMAL(18, 2), SUBSTRING(@item, CHARINDEX(',', @item) + 1, LEN(@item)));

        -- Atualiza��o do VPL acumulado
        SET @npv = @npv + (@value / POWER(1 + @rate, @period));

        -- Atualiza��o da string de fluxos de caixa para processar o pr�ximo item
        SET @cashFlows = CASE 
                            WHEN CHARINDEX(';', @cashFlows) > 0 
                            THEN SUBSTRING(@cashFlows, CHARINDEX(';', @cashFlows) + 1, LEN(@cashFlows))
                            ELSE ''
                         END;
    END;

    RETURN @npv; -- Retorna o Valor Presente L�quido calculado
END;

-- Exemplo de Uso: Calcula o VPL para os fluxos de caixa fornecidos e taxa de desconto
SELECT dbo.CalculateNPV(0.1, '1,500;2,600;3,700') AS NPV;
