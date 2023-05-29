ETAPA 2 - Controle de Segurança

Para atender a legislação, o acesso a determinadas estruturas e dados serão limitados e controlados para determinados usuários. Para isso, são listadas algumas diretrizes:

a) Haverá 03 (três) grupos (papéis) de usuários do sistema: Gerente, Recepcionista e o Atendente Geral;

b) O grupo "Gerente" poderá realizar qualquer operação sobre os dados, além de definir acesso (conceder direitos - ver "with grant option") a outros usuários;;

c) O grupo "Recepcionista" poderá realizar todas as operações sobre as estruturas: cliente, reserva e hospedagem;

d) O grupo de usuários "Atendente Geral" poderá apenas realizar leitura dos dados do cliente (nome e número do quarto em que está hospedado) e realizar operações de inclusão e alteração na estrutura hospedagem serviço. Dica: avaliar possibilidade de utilização de uma visão (view) pra limitar o acesso aos dados do cliente/hospedagem.

Considerando o exposto, pede-se à esta etapa 2, sentenças SQL para:

1) Criação dos grupos (papéis);

2) Designação dos privilégios para cada um dos grupos criados;

3) Criação de, no mínimo, um usuário para cada grupo criado;

4) Efetuar o login na interface de sua preferência (ferramenta de interação: ex. HeidiSQL) com um usuário de cada papel, realizando sequência de comandos para validar os mecanismos de segurança implementados. É necessário o registro de cada operação por meio de "prints" de tela exibindo mensagem de sucesso/insucesso em cada operação simulada, assim como a limitação de operações não autorizadas;

As etapas (devidamente identificadas) com as respectivas sentenças SQL (devidamente identificadas), assim como os registros dos testes realizados (devidamente identificados), devem estar em um arquivo padrão PDF (salve o arquivo com seu nome). Uma vez concluída a atividade, faça o upload do arquivo para a plataforma AVA3.