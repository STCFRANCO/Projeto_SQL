1- Clientes que são dependentes

select conta.numero as conta,cliente_pai ,nome as cliente_dependente
from cliente
join cliente_conta on cliente_conta.id_cliente=cliente.id 
join (select cliente.nome as cliente_pai,cliente_conta.id_conta as conta_pai
      from cliente 
      join cliente_conta on cliente_conta.id_cliente=cliente.id 
      where dependente=false) as clientes_pai
	on conta_pai = cliente_conta.id_conta
join conta on conta.id=cliente_conta.id_conta
where dependente=true
order by conta;


2- transaçoes 
 As 5 contas que Mais fizeram transações

select conta.numero as conta,count(transacao.id) as transacoes
from transacao
join cliente_conta on cliente_conta.id=transacao.id_cliente_conta
join conta on conta.id=cliente_conta.id_conta
group by id_cliente_conta
order by transacoes desc
limit 5;

 As 5 contas que menos fizeram transações

select conta.numero as conta,count(transacao.id) as transacoes
from transacao
join cliente_conta on cliente_conta.id=transacao.id_cliente_conta
join conta on conta.id=cliente_conta.id_conta
group by id_cliente_conta
order by transacoes
limit 5;


3-Saldo total das contas registradas em banco 

select conta.numero as conta,depositos.total_depositos, debitos.total_debitos, (depositos.total_depositos-debitos.total_debitos) as saldo
from conta
join (select conta.numero as conta,sum(valor) as total_depositos
	from transacao
	join cliente_conta on cliente_conta.id=transacao.id_cliente_conta
	join conta on conta.id=cliente_conta.id_conta
	where id_tipo_transacao=1
	group by conta) as depositos 
on depositos.conta=conta.numero
join (select conta.numero as conta,sum(valor) as total_debitos
	from transacao
	join cliente_conta on cliente_conta.id=transacao.id_cliente_conta
	join conta on conta.id=cliente_conta.id_conta
	where id_tipo_transacao<>1
	group by conta)as debitos
on debitos.conta=conta.numero;