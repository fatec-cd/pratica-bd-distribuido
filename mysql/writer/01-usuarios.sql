-- =============================================================================
-- mysql-writer · executado uma única vez, quando o contêiner é criado
-- =============================================================================
-- sql_log_bin = 0: estes comandos não vão para o binlog e, portanto,
-- NÃO são replicados — cada servidor cria os próprios usuários.
SET SESSION sql_log_bin = 0;

-- Usuário que a réplica usa para ler o binlog do Writer
CREATE USER 'replicador'@'%' IDENTIFIED BY 'replica-lab';
GRANT REPLICATION SLAVE ON *.* TO 'replicador'@'%';

-- Usuário dos alunos (Sessão A)
CREATE USER 'aluno'@'%' IDENTIFIED BY 'aluno-lab';
GRANT ALL PRIVILEGES ON ecommerce_central.* TO 'aluno'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'aluno'@'%';

SET SESSION sql_log_bin = 1;
