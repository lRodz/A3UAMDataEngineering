--1. Criação do DB e tabelas:

-- Criação do banco de dados
CREATE DATABASE CashFlowDB;
USE CashFlowDB;

-- Tabela de Contas
CREATE TABLE Accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID incremental para identificação única
    account_name VARCHAR(50) NOT NULL,        -- Nome da conta, obrigatório
    account_type VARCHAR(20) NOT NULL,        -- Tipo da conta (ex.: corrente, poupança)
    initial_balance FLOAT NOT NULL            -- Saldo inicial da conta
);

-- Tabela de Categorias
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,  -- ID incremental para identificação única
    category_name VARCHAR(50) NOT NULL,        -- Nome da categoria, obrigatório
    category_type VARCHAR(10) NOT NULL         -- Tipo da categoria (ex.: receita, despesa)
);

-- Tabela de Centros de Custo
CREATE TABLE CostCenters (
    cost_center_id INT IDENTITY(1,1) PRIMARY KEY, -- ID incremental para identificação única
    cost_center_name VARCHAR(50) NOT NULL,       -- Nome do centro de custo, obrigatório
    description VARCHAR(200)                     -- Descrição opcional
);

-- Tabela de Formas de Pagamento
CREATE TABLE PaymentMethods (
    payment_method_id INT IDENTITY(1,1) PRIMARY KEY, -- ID incremental para identificação única
    payment_type VARCHAR(20) NOT NULL               -- Tipo de pagamento (ex.: crédito, débito)
);

-- Tabela de Movimentações Financeiras
CREATE TABLE FinancialMovements (
    movement_id INT IDENTITY(1,1) PRIMARY KEY,       -- ID incremental para identificação única
    movement_date DATE NOT NULL,                     -- Data da movimentação, obrigatório
    amount DECIMAL(12, 2) NOT NULL,                  -- Valor da movimentação
    description VARCHAR(200),                        -- Descrição opcional
    account_id INT NOT NULL,                         -- ID da conta relacionada
    category_id INT NOT NULL,                        -- ID da categoria relacionada
    cost_center_id INT,                              -- ID do centro de custo (opcional)
    payment_method_id INT NOT NULL,                  -- ID da forma de pagamento relacionada
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),           -- Chave estrangeira para tabela de contas
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),       -- Chave estrangeira para tabela de categorias
    FOREIGN KEY (cost_center_id) REFERENCES CostCenters(cost_center_id),-- Chave estrangeira para tabela de centros de custo
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods(payment_method_id) -- Chave estrangeira para tabela de formas de pagamento
);

--2. Criação de índices e facilitadores:

-- Índice para facilitar buscas por account_id na tabela FinancialMovements
CREATE INDEX IDX_FinancialMovements_AccountID ON FinancialMovements(account_id);

-- Índice para facilitar buscas por category_id na tabela FinancialMovements
CREATE INDEX IDX_FinancialMovements_CategoryID ON FinancialMovements(category_id);

-- Índice para facilitar buscas por movement_date na tabela FinancialMovements
CREATE INDEX IDX_FinancialMovements_MovementDate ON FinancialMovements(movement_date);

-- Índices adicionais para otimizar consultas específicas
CREATE INDEX IDX_FinancialMovements_PaymentMethodID ON FinancialMovements(payment_method_id); -- Busca por formas de pagamento
CREATE INDEX IDX_FinancialMovements_CostCenterID ON FinancialMovements(cost_center_id);       -- Busca por centros de custo

-- Adiciona valor padrão para movement_date, preenchendo automaticamente a data atual caso não especificado
ALTER TABLE FinancialMovements 
ADD DEFAULT GETDATE() FOR movement_date;



--3. População de tabelas para validação:

-- Inserção de dados na tabela Accounts, representando diferentes tipos de contas
INSERT INTO Accounts (account_name, account_type, initial_balance)
VALUES
('Conta Corrente', 'C', 5000.00),          -- Conta corrente com saldo inicial
('Poupança', 'P', 10000.00),              -- Conta poupança com saldo inicial
('Conta de Investimentos', 'I', 20000.00); -- Conta de investimentos com saldo inicial

-- Inserção de dados na tabela Categories, incluindo receitas e despesas
INSERT INTO Categories (category_name, category_type)
VALUES 
('Salário', 'R'),                        -- Receita: Salário
('Aluguel', 'D'),                        -- Despesa: Aluguel
('Compra de Equipamentos', 'D'),         -- Despesa: Compra de equipamentos
('Venda de Produto', 'R'),               -- Receita: Venda de produto
('Compra de Materiais', 'D');            -- Despesa: Compra de materiais

-- Inserção de dados na tabela CostCenters, representando centros de custo da empresa
INSERT INTO CostCenters (cost_center_name, description)
VALUES 
('Administração', 'Despesas administrativas gerais'), -- Centro de custo para administração
('TI', 'Tecnologia da Informação'),                  -- Centro de custo para TI
('Marketing', 'Promoção e publicidade');             -- Centro de custo para marketing

-- Inserção de dados na tabela PaymentMethods, representando formas de pagamento
INSERT INTO PaymentMethods (payment_type)
VALUES 
('Dinheiro'),                  -- Pagamento em dinheiro
('Cartão de Crédito'),         -- Pagamento com cartão de crédito
('Transferência');             -- Pagamento por transferência bancária


-- Inserção de dados na tabela FinancialMovements, exemplificando movimentações financeiras
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2024-12-01', 5000.00, 'Salário recebido', 1, 1, NULL, 1),             -- Receita de salário
('2024-12-02', -1500.00, 'Pagamento de aluguel', 1, 2, 1, 2),          -- Despesa com aluguel
('2024-12-03', 2000.00, 'Venda de Produto A', 2, 4, 2, 1),             -- Receita de venda de produto
('2024-12-04', -500.00, 'Compra de Material de Escritório', 1, 5, 3, 3); -- Despesa com compra de materiais

-- December 2024
INSERT INTO FinancialMovements (movement_date, amount, description, account_id, category_id, cost_center_id, payment_method_id)
VALUES 
('2024-12-15', 3000.00, 'Bonus recebido', 1, 1, NULL, 1),
('2024-12-20', -800.00, 'Manutenção do escritório', 1, 5, 3, 3);

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
('2025-03-25', 2500.00, 'Venda de serviço', 1, 4, 2, 1);

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


--4. Criação de Stored Procedures:

-- Stored Procedure: Cálculo do Saldo do Fluxo de Caixa
CREATE PROCEDURE GetCashFlowBalance
AS
BEGIN
    SELECT 
        a.account_id,  -- ID da conta
        a.account_name, -- Nome da conta
        SUM(CASE WHEN c.category_type = 'R' THEN f.amount ELSE -f.amount END) AS current_balance -- Saldo atual calculado
    FROM 
        Accounts a
    LEFT JOIN FinancialMovements f ON a.account_id = f.account_id -- Relaciona contas às movimentações financeiras
    LEFT JOIN Categories c ON f.category_id = c.category_id       -- Relaciona movimentações às categorias
    GROUP BY a.account_id, a.account_name; -- Agrupa por conta para consolidar os saldos
END;

-- Executa a stored procedure para calcular o saldo do fluxo de caixa
EXEC GetCashFlowBalance;



-- Stored Procedure: Geração de Relatórios de Receitas e Despesas
CREATE PROCEDURE GetIncomeExpenseReport
AS
BEGIN
    SELECT 
        c.category_type, -- Tipo da categoria (Receita ou Despesa)
        c.category_name, -- Nome da categoria
        SUM(f.amount) AS total_amount -- Total acumulado por categoria
    FROM 
        FinancialMovements f
    JOIN Categories c ON f.category_id = c.category_id -- Relaciona movimentações às categorias
    GROUP BY c.category_type, c.category_name; -- Agrupa por tipo e nome da categoria
END;

-- Executa a stored procedure para gerar o relatório de receitas e despesas
EXEC GetIncomeExpenseReport;



-- Stored Procedure: Projeção de Fluxo de Caixa Futuro
CREATE PROCEDURE GetCashFlowProjection (@months INT)
AS
BEGIN
    -- Cria uma tabela temporária de números para projeção mensal
    WITH Numbers AS (
        SELECT TOP (@months) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS number
        FROM master.dbo.spt_values -- Tabela do sistema usada para gerar uma sequência de números
    )
    SELECT 
        DATEADD(MONTH, n.number - 1, GETDATE()) AS projected_month, -- Mês projetado
        SUM(CASE WHEN c.category_type = 'R' THEN f.amount ELSE -f.amount END) AS projected_balance -- Saldo projetado
    FROM 
        FinancialMovements f
    JOIN Categories c ON f.category_id = c.category_id -- Relaciona movimentações às categorias
    CROSS JOIN Numbers n -- Combina cada mês projetado com os dados financeiros
    WHERE 
        f.movement_date BETWEEN DATEADD(MONTH, n.number - 1, GETDATE()) AND DATEADD(MONTH, n.number, GETDATE()) -- Movimentações no intervalo do mês
    GROUP BY n.number -- Agrupa por mês projetado
    ORDER BY projected_month; -- Ordena os resultados por mês
END;

-- Executa a stored procedure para calcular a projeção do fluxo de caixa para os próximos 6 meses
EXEC GetCashFlowProjection @months = 6;



-- Placeholder para TIR (Taxa Interna de Retorno)
-- A criação do tipo "CashFlowTable" inicia a estrutura para operações financeiras avançadas
CREATE TYPE CashFlowTable AS TABLE (
    period INT,           -- Período de tempo do fluxo de caixa
    value DECIMAL(18, 2)  -- Valor associado ao período
);



-- Stored Procedure para o cálculo aproximado da Taxa Interna de Retorno (TIR)
CREATE PROCEDURE CalculateIRR
(
    @cashFlows CashFlowTable READONLY, -- Parâmetro tabela para fluxos de caixa, somente leitura
    @initialGuess DECIMAL(5, 4),       -- Chute inicial para o cálculo da TIR
    @irrResult DECIMAL(5, 4) OUTPUT    -- Parâmetro de saída para armazenar o resultado da TIR
)
AS
BEGIN
    -- Declaração de variáveis internas
    DECLARE @rate DECIMAL(5, 4) = @initialGuess; -- Taxa inicial de desconto
    DECLARE @tolerance DECIMAL(5, 4) = 0.0001;   -- Tolerância para o erro no cálculo
    DECLARE @maxIterations INT = 1000;          -- Número máximo de iterações permitidas
    DECLARE @iteration INT = 0;                 -- Contador de iterações
    DECLARE @npv DECIMAL(18, 4);                -- Valor Presente Líquido (NPV)
    DECLARE @derivative DECIMAL(18, 4);         -- Derivada da função NPV para o método de Newton-Raphson

    -- Loop de cálculo usando o método de Newton-Raphson
    WHILE @iteration < @maxIterations
    BEGIN
        -- Inicializa NPV e derivada para cada iteração
        SET @npv = 0;
        SET @derivative = 0;

        -- Calcula o NPV e sua derivada com base nos fluxos de caixa
        SELECT 
            @npv = @npv + (value / POWER(1 + @rate, period)),       -- Soma do valor descontado
            @derivative = @derivative - (period * value / POWER(1 + @rate, period + 1)) -- Derivada parcial
        FROM @cashFlows;

        -- Verifica se o NPV está próximo de zero
        IF ABS(@npv) < @tolerance
            BREAK;

        -- Atualiza a taxa de desconto usando o método de Newton-Raphson
        SET @rate = @rate - (@npv / @derivative);

        -- Incrementa o contador de iterações
        SET @iteration = @iteration + 1;
    END;

    -- Define o resultado final da TIR
    SET @irrResult = @rate;
END;


-- Exemplo de uso da Stored Procedure para calcular a TIR(Executar as linhas abaixo em conjunto)

--1. Declaração de uma variável tabela para fluxos de caixa
DECLARE @cashFlows CashFlowTable;

--2. Inserção de dados de exemplo de fluxo de caixa
INSERT INTO @cashFlows (period, value)
VALUES (0, -1000), (1, 500), (2, 600), (3, 700); -- Fluxo de caixa típico com valores para diferentes períodos

--3. Declaração de uma variável para capturar o resultado da TIR
DECLARE @irrResult DECIMAL(5, 4);

--4. Execução da stored procedure com os fluxos de caixa e o chute inicial
EXEC CalculateIRR @cashFlows = @cashFlows, @initialGuess = 0.1, @irrResult = @irrResult OUTPUT;

--5. Exibição do resultado da TIR
SELECT @irrResult AS 'Taxa Interna de Retorno (TIR)'; -- Resultado final para análise




-- 5. Criação de Funções Úteis

-- Função para Cálculo de Juros Compostos
CREATE FUNCTION CalculateCompoundInterest
(
    @principal DECIMAL(18, 2), -- Valor presente (PV)
    @rate DECIMAL(5, 4),       -- Taxa de juros (r)
    @time INT                  -- Número de períodos (n)
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    RETURN @principal * POWER(1 + @rate, @time); -- Fórmula de juros compostos
END;

-- Exemplo de Uso: Calcula o valor futuro com base nos parâmetros fornecidos
SELECT dbo.CalculateCompoundInterest(1000, 0.05, 12) AS ValorFuturo;


-- Função para Cálculo do Valor Presente Líquido (VPL)
CREATE FUNCTION CalculateNPV
(
    @rate DECIMAL(5, 4),       -- Taxa de desconto
    @cashFlows NVARCHAR(MAX)   -- Fluxos de caixa no formato: "1,500;2,600;3,700"
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    -- Declaração de variáveis para processamento
    DECLARE @npv DECIMAL(18, 2) = 0; -- Valor Presente Líquido acumulado
    DECLARE @index INT = 1;          -- Índice de controle
    DECLARE @item NVARCHAR(100);     -- Item atual extraído da string
    DECLARE @period INT;             -- Período extraído do item
    DECLARE @value DECIMAL(18, 2);   -- Valor extraído do item

    -- Processamento da string delimitada para calcular o VPL
    WHILE CHARINDEX(';', @cashFlows) > 0 OR LEN(@cashFlows) > 0
    BEGIN
        -- Extração do item atual (período e valor)
        SET @item = CASE 
                       WHEN CHARINDEX(';', @cashFlows) > 0 
                       THEN LEFT(@cashFlows, CHARINDEX(';', @cashFlows) - 1)
                       ELSE @cashFlows
                   END;

        -- Separação do período e valor a partir do item
        SET @period = CONVERT(INT, LEFT(@item, CHARINDEX(',', @item) - 1));
        SET @value = CONVERT(DECIMAL(18, 2), SUBSTRING(@item, CHARINDEX(',', @item) + 1, LEN(@item)));

        -- Atualização do VPL acumulado
        SET @npv = @npv + (@value / POWER(1 + @rate, @period));

        -- Atualização da string de fluxos de caixa para processar o próximo item
        SET @cashFlows = CASE 
                            WHEN CHARINDEX(';', @cashFlows) > 0 
                            THEN SUBSTRING(@cashFlows, CHARINDEX(';', @cashFlows) + 1, LEN(@cashFlows))
                            ELSE ''
                         END;
    END;

    RETURN @npv; -- Retorna o Valor Presente Líquido calculado
END;

-- Exemplo de Uso: Calcula o VPL para os fluxos de caixa fornecidos e taxa de desconto
SELECT dbo.CalculateNPV(0.1, '1,500;2,600;3,700') AS NPV;
