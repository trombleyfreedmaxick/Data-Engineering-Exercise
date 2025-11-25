{{ config(
    materialized="view"
) }}

with source_data as (
    select
        OrderId::INTEGER as OrderId,
        Product,
        QuantityOrdered::INTEGER as QuantityOrdered,
        PriceEach::DECIMAL(10,2) as PriceEach,
        OrderDate::TIMESTAMP as OrderDate,
        CityStore,
        Category,
        OrderStatus,
        QuantityOrdered::INTEGER * PriceEach::DECIMAL(10,2) as TotalAmount
    from read_csv_auto("data/SalesOrders.csv", header=true)
)

select * from source_data
stage_sales_orders.sql
