/* Após a criação da tabela elmasri no sql power arcthect, vou ao terminal do vitual box criar um usuario do banco de dados do mariabd

su - root 
computacao@raiz 

mysql -u root -p
computacao@raiz

show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.086 sec)

SELECT user FROM mysql.user;
+-------------+
| User        |
+-------------+
| mariadb.sys |
| mysql       |
| root        |
+-------------+

create user thierry identified by '123456';

/* Após eu criar o usuário, vou criar o banco de dados da uvv  dar os devidor privilégios para o meu usuário criado

create database uvv;

grant all privileges on uvv.* to thierry;

SELECT user FROM mysql.user;
+-------------+
| User        |
+-------------+
| thierry     |
| mariadb.sys |
| mysql       |
| root        |
+-------------+

show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| uvv                |
+--------------------+



su - root
computacao@raiz 

mysql -u root -p
computacao@raiz 


system mysql -u thierry -p
123456

use uvv;



/* depois de usar todos os comando, vou criar as tabela com as suas devidas restrições






CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(70),
                sexo CHAR(1),
                salario DECIMAL(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INT NOT NULL,
                PRIMARY KEY (cpf)
);

ALTER TABLE funcionario COMMENT 'Tabela que armazena as informações dos funcionários.';

ALTER TABLE funcionario MODIFY COLUMN cpf CHAR(11) COMMENT 'CPF do funcionário. Será a PK da tabela.';

ALTER TABLE funcionario MODIFY COLUMN primeiro_nome VARCHAR(15) COMMENT 'Primeiro nome do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN nome_meio CHAR(1) COMMENT 'Inicial do nome do meio.';

ALTER TABLE funcionario MODIFY COLUMN ultimo_nome VARCHAR(15) COMMENT 'Sobrenome do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN endereco VARCHAR(70) COMMENT 'Endereço do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN sexo CHAR(1) COMMENT 'Sexo do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN salario DECIMAL(10, 2) COMMENT 'Salário do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN cpf_supervisor CHAR(11) COMMENT 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).';

ALTER TABLE funcionario MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento do funcionário.';


CREATE TABLE departamento (
                numero_departamento INT NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                PRIMARY KEY (numero_departamento)
);

ALTER TABLE departamento COMMENT 'Tabela que armazena as informaçoẽs dos departamentos.';

ALTER TABLE departamento MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É a PK desta tabela.';

ALTER TABLE departamento MODIFY COLUMN nome_departamento VARCHAR(15) COMMENT 'Nome do departamento. Deve ser único.';

ALTER TABLE departamento MODIFY COLUMN cpf_gerente CHAR(11) COMMENT 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';

ALTER TABLE departamento MODIFY COLUMN data_inicio_gerente DATE COMMENT 'Data do início do gerente no departamento.';


CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( nome_departamento );

CREATE TABLE localizacoes_departamento (
                numero_departamento INT NOT NULL,
                local VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_departamento, local)
);

ALTER TABLE localizacoes_departamento MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É a PK desta tabela.';

ALTER TABLE localizacoes_departamento MODIFY COLUMN local VARCHAR(15) COMMENT 'Localização do departamento. Faz parte da PK desta tabela.';


CREATE TABLE projeto (
                numero_projeto INT NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INT NOT NULL,
                PRIMARY KEY (numero_projeto)
);

ALTER TABLE projeto COMMENT 'Tabela que armazena as informações sobre os projetos dos departamentos.';

ALTER TABLE projeto MODIFY COLUMN numero_projeto INTEGER COMMENT 'Número do projeto. É a PK desta tabela.';

ALTER TABLE projeto MODIFY COLUMN nome_projeto VARCHAR(15) COMMENT 'Nome do projeto. Deve ser único.';

ALTER TABLE projeto MODIFY COLUMN local_projeto VARCHAR(15) COMMENT 'Localização do projeto.';

ALTER TABLE projeto MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É uma FK para a tabela departamento.';


CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INT NOT NULL,
                horas DECIMAL(3,1) NOT NULL,
                PRIMARY KEY (cpf_funcionario, numero_projeto)
);

ALTER TABLE trabalha_em COMMENT 'Tabela para armazenar quais funcionários trabalham em quais projetos.';

ALTER TABLE trabalha_em MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'Tabela para armazenar quais funcionários trabalham em quais projetos.';

ALTER TABLE trabalha_em MODIFY COLUMN numero_projeto INTEGER COMMENT 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';

ALTER TABLE trabalha_em MODIFY COLUMN horas DECIMAL(3, 1) COMMENT 'Horas trabalhadas pelo funcionário neste projeto.';


CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                PRIMARY KEY (cpf_funcionario, nome_dependente)
);

ALTER TABLE dependente COMMENT 'Tabela que armazena as informações dos dependentes dos funcionários.';

ALTER TABLE dependente MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

ALTER TABLE dependente MODIFY COLUMN nome_dependente VARCHAR(15) COMMENT 'Nome do dependente. Faz parte da PK desta tabela.';

ALTER TABLE dependente MODIFY COLUMN sexo CHAR(1) COMMENT 'Sexo do dependente.';

ALTER TABLE dependente MODIFY COLUMN data_nascimento DATE COMMENT 'Data de nascimento do dependente.';

ALTER TABLE dependente MODIFY COLUMN parentesco VARCHAR(15) COMMENT 'Descrição do parentesco do dependente com o funcionário.';


ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

/*Depois de criar todas as tabela vou inserit os devidos dados para cada tipo de tabela.



INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('88866555576', 'Jorge', 'E', 'Brito', '1937-11-10','RuadoHorto35,SãoPaulo,SP', 'M', '55000', '88866555576', 1 );
INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('98765432168', 'Jennifer', 'S', 'Souza', '1941-06-20','AvArthurLima54,SantoAndré,SP', 'F', '43000', '88866555576', 4 );
INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) VALUES ('99988777767', 'Alice', 'J', 'Zelaya', '1968-01-19','RuaSouzaLima35,Curitiba,PR', 'F', '25000', '98765432168', 4 );
INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('98798798733','André', 'V','Pereira', '1969-03-29','RuaTimbira35,SãoPaulo,SP', 'M', '25000', '98765432168', 4 );
INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('33344555587', 'Fernando', 'T', 'Wong', '1955-12-08','RuadaLapa34,São Paulo,SP', 'M', '40000', '88866555576', 5 );
INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('12345678966', 'João', 'B', 'Silva', '1965-01-09','RuadasFlores751,SãoPaulo,SP', 'M', '30000', '33344555587', 5 );
INSERT INTO funcionario (cpf,primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('66688444476', 'Ronaldo', 'K', 'Lima', '1962-09-15','RuaRebouças65,Piracicaba,SP', 'M', '38000', '33344555587', 5 );
INSERT INTO funcionario (cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('45345345376','Joice', 'A', 'Leite', '1972-07-31','AvLucasObes74,SãoPaulo,SP', 'F', '25000', '33344555587', 5 );


INSERT INTO departamento ( nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES( 'Matriz', 1, '88866555576', '1981-06-19');
INSERT INTO departamento ( nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES( 'Pesquisa', 5, '33344555587', '1988-05-22');
INSERT INTO departamento ( nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES( 'Administração', 4, '98765432168', ' 1995-01-01');


INSERT INTO localizacoes_departamento( numero_departamento, local)
VALUES( 1, ' São Paulo');
INSERT INTO localizacoes_departamento( numero_departamento, local)
VALUES( 4, ' Mauá');
INSERT INTO localizacoes_departamento( numero_departamento, local)
VALUES( 5, ' Santo André');
INSERT INTO localizacoes_departamento( numero_departamento, local)
VALUES( 5, ' Itu');
INSERT INTO localizacoes_departamento( numero_departamento, local)
VALUES( 5, ' São Paulo');


INSERT INTO projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'ProdutoX', 1, 'Santo André', 5);
INSERT INTO projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'ProdutoY', 2, 'Itu', 5);
INSERT INTO projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'ProdutoZ', 3, 'São Paulo', 5);
INSERT INTO projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'Informatização', 10, 'Mauá', 4);
INSERT INTO projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'Reorganização', 20, 'São Paulo', 1);
INSERT INTO projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'Novosbenefícios', 30, 'Mauá', 4);



INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '12345678966', 1, '32.5');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '12345678966', 2, '7.5');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '66688444476', 3, '40.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '45345345376', 1, '20.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '45345345376', 2, '20.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 2, '10.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 3, '10.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 10, '10.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 20, '10.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '99988777767', 30, '30.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '99988777767', 10, '10.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98798798733', 10, '35.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98798798733', 30, '5.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98765432168', 30, '20.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98765432168', 20, '15.0');
INSERT INTO trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '88866555576', 20, '0');



INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '33344555587', 'Alícia', 'F', '1986-04-05', 'Filha');
INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '33344555587', 'Tiago', 'M', '1983-10-25', 'Filho');
INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa');
INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '98765432168', 'Antonio', 'M', '1942-02-28', 'Marido');
INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '12345678966', 'Michael', 'M', '1988-01-04', 'Filho');
INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '12345678966', 'Alícia', 'F', '1988-12-30', 'Filha');
INSERT INTO dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');
