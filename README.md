# Análise de dados de um varejo de bicicleta no SQL
![christin-hume-zbUH21c9ARk-unsplash](https://github.com/user-attachments/assets/443e985c-4989-45ef-a605-39d9cf662909)

## Sobre o projeto:
Procurei entender algumas métricas de negócio das diferentes lojas, como lucros e custos e quais são as determinantes da rentabilidade do modelo de negócio. Para isso, utilizei o SQL, em que tive que 
- criar tabelas e adicionar valores de margens por meio da função CASE;
- utilizei CTEs para mesclar duas diferentes tabelas para conjugar diferentes informações, como categoria do produto vendido, bem como sua quantidade e preço;
- finalmente, fiz uma análise geral de receitas, quantidades vendidas e lucros, além de tentar perceber quais lojas são as mais rentáveis e qual época do ano se vende mais bicicletas.

- Análise completa: https://medium.com/@eduardoguarienti/an%C3%A1lise-de-um-varejo-de-bicicletas-no-sql-75885c4de940

## Sobre os dados:
Utilizei um conjunto de dados disponível no Kaggle sobre bases de dados relacionais:
- https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database

## Insights gerais:
- As receitas são quase o dobro da margem de lucro total;
- Apesar do lucro médio aumentar em 2018, a lucratividade do varejo em questão aparenta centrar-se na quantidade vendida;
- As três diferentes lojas têm três diferentes padrões de vendas, com a mais rentável sendo a nova-iorquina, que vende muito mais que a loja texana;
- O lucro médio não aparenta ter relação com o lucro total de cada loja;
- A loja californiana apresenta resultados mais estáveis, porém intermediários;
- Cada cliente faz poucos ou apenas 1 pedido, o que acompanha a premissa que não compramos muitas bicicletas de uma vez só;
- Pode ser que haja uma sazonalidade nas vendas: os meses que antecedem o verão do hemisfério norte apresentam a maior quantidade vendida.
