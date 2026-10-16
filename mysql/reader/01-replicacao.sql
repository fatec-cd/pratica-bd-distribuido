-- =============================================================================
-- mysql-reader · executado uma única vez, quando o contêiner é criado
-- =============================================================================
SET SESSION sql_log_bin = 0;

-- Usuário dos alunos (Sessão B). Tem os mesmos privilégios da Sessão A:
-- quem impede a escrita aqui é o modo somente leitura do servidor, não a falta de permissão.
CREATE USER 'aluno'@'%' IDENTIFIED BY 'aluno-lab';
GRANT ALL PRIVILEGES ON ecommerce_central.* TO 'aluno'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'aluno'@'%';

SET SESSION sql_log_bin = 1;

-- Aponta a réplica para o Writer. SOURCE_AUTO_POSITION = 1 usa os GTIDs para saber
-- de onde continuar, inclusive depois que a réplica fica um tempo fora do ar.
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST = 'mysql-writer',
  SOURCE_PORT = 3306,
  SOURCE_USER = 'replicador',
  SOURCE_PASSWORD = 'replica-lab',
  SOURCE_AUTO_POSITION = 1,
  GET_SOURCE_PUBLIC_KEY = 1;

START REPLICA;

-- Somente leitura para todos os usuários (super_read_only vale até para o root).
-- SET PERSIST grava a configuração no próprio servidor: ela vale também após reinícios.
SET PERSIST read_only = ON;
SET PERSIST super_read_only = ON;
