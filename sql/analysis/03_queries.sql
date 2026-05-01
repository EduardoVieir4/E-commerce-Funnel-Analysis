-- QUANTIDADE DE:
-- quantidade de produtos vistos (viewed_product)
select
	sum(visited_website) as visitas_website,
	sum(viewed_product) as produtos_visitados,
	sum(added_to_cart) as adicionados_ao_carrinho,
	sum(checkout_started) as compras_iniciada,
	sum(purchase_completed) as pagamentos_finalizados
from analytics.funnel

-- conversão entre as etapas do funil
select
	sum(viewed_product)::float / sum(visited_website) as visitaWebsite_produtosVisitados,
	sum(added_to_cart)::float / sum(viewed_product) as produtosVisitados_carrinho,
	sum(checkout_started)::float / sum(added_to_cart) as carrinho_comprasIniciadas,
	sum(purchase_completed)::float / sum(checkout_started) as comprasIniciadas_pagamentoFeito
from analytics.funnel


-- quantidade de vendas pelo tipo de campanha
select
	ses.campaign_type,
	sum(fun.purchase_completed) as vendas
from analytics.funnel as fun
left join analytics.sessions as ses
	on fun.session_id = ses.session_id
group by ses.campaign_type
order by vendas desc

----------------------------------------------- PROJETO ----------------------------------------------------------------

--FUNIL
-- Qual a taxa de conversão geral?
select
	sum(purchase_completed)::float/sum(visited_website) as conversao_geral
from analytics.funnel

-- Onde ocorre a maior perda de clientes?
select
	1 - (sum(viewed_product)::float / sum(visited_website)) as visitaWebsite_produtosVisitados,
	1 - (sum(added_to_cart)::float / sum(viewed_product)) as produtosVisitados_carrinho,
	1 - (sum(checkout_started)::float / sum(added_to_cart)) as carrinho_comprasIniciadas,
	1 - (sum(purchase_completed)::float / sum(checkout_started)) as comprasIniciadas_pagamentoFeito
from analytics.funnel

-- PERFORMANCE
-- Qual canal gera mais receita?
select
	ses.channel as canal, 
	sum(revenue)/1 as receita
from analytics.sessions as ses
left join analytics.funnel as fun
	on ses.session_id = fun.session_id
group by canal
order by receita desc

--Qual canal converte melhor?
select
	s.channel as canal,
	sum(f.purchase_completed)::float / sum(f.visited_website) as conversao
from analytics.funnel as f
left join analytics.sessions as s
	on s.session_id = f.session_id
group by s.channel
order by conversao desc

-- COMPORTAMENTO
-- Mobile converte menos que desktop?
select
	c.device as dispositivo,
	sum(f.purchase_completed)::float / sum(f.visited_website) as conversao
from analytics.funnel as f
left join analytics.customers as c
	on f.user_id = c.user_id
group by dispositivo
order by conversao desc

-- Usuários novos vs recorrentes convertem diferente?

SELECT
    c.user_type,
    SUM(f.revenue/1000) AS receita,
    SUM(f.purchase_completed)::float / SUM(f.visited_website) AS conversao
FROM analytics.funnel f
JOIN analytics.customers c
    ON f.user_id = c.user_id
GROUP BY c.user_type

-- SEGMENTAÇÃO
-- Quais regiões são mais lucrativas?
select
	c.region,
	sum(revenue/1000) as receita
from analytics.funnel as f
left join analytics.customers as c
	on f.user_id = c.user_id
group by c.region
order by receita desc

-- Receita e Ticket médio ao longo do tempo

select
	date_trunc('month', ses.date)::date as mes,
	sum(fun.revenue/1000) as receita,
	sum(fun.revenue) / nullif(sum(purchase_completed), 0) as ticket_medio
from analytics.funnel as fun
join analytics.sessions as ses
	on fun.session_id = ses.session_id
group by mes
order by mes