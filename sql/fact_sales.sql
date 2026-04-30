-- ============================================
-- View Name: fact_sales
-- Description:
-- This view creates a consolidated sales dataset by combining
-- orders, customers, products, and office information.
-- It acts as a fact table for sales analysis.
-- ============================================

create or replace view fact_sales as

select 
    -- Order information
    orderdate,
    ord.ordernumber,

    -- Product details
    p.productName,
    p.productLine,

    -- Customer details
    cu.customerName,
    cu.country as customer_country,

    -- Office (sales region) details
    o.country as office_country,

    -- Pricing and quantity
    buyprice,                 -- Cost price of the product
    priceEach,                -- Selling price per unit
    quantityOrdered,

    -- Calculated metrics
    quantityOrdered * priceEach as sales_value,     -- Total revenue
    quantityOrdered * buyPrice as cost_of_sales     -- Total cost

from orders ord

-- Join order details to get product-level transactions
inner join orderdetails orddet
    on ord.orderNumber = orddet.orderNumber

-- Join customers to get customer-related information
inner join customers cu
    on ord.customerNumber = cu.customerNumber

-- Join products to get product details
inner join products p
    on orddet.productCode = p.productCode

-- Join employees to link customers with sales representatives
inner join employees emp
    on cu.salesRepEmployeeNumber = emp.employeeNumber

-- Join offices to determine the sales region
inner join offices o
    on emp.officeCode = o.officeCode;