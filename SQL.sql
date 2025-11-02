CREATE TABLE rakamin-kf-analytics-11.kimia_farma.kf_analisa AS
WITH CTE1 AS
(SELECT
DISTINCT product_id, price,
CASE
 WHEN price <= 50000 THEN 0.1
 WHEN price > 50000 AND price <= 100000 THEN 0.15
 WHEN price > 100000 AND price <= 300000 THEN 0.2
 WHEN price > 300000 AND price <= 500000 THEN 0.25
 ELSE 0.3
END AS persentase_gross_laba
FROM `rakamin-kf-analytics-11.kimia_farma.kf_final_transaction`
)
SELECT
tr.transaction_id,
tr.date,
tr.branch_id,
br.branch_name,
br.kota,
br.provinsi,
br.rating rating_cabang,
tr.customer_name,
tr.product_id,
pr.product_name,
pr.price actual_price,
tr.discount_percentage,
c1.persentase_gross_laba,
tr.price * (1 - tr.discount_percentage) nett_sales,
(tr.price * (1 - tr.discount_percentage)) * c1.persentase_gross_laba nett_profit,
tr.rating rating_transaksi
FROM `rakamin-kf-analytics-11.kimia_farma.kf_final_transaction` tr
  JOIN `rakamin-kf-analytics-11.kimia_farma.kf_kantor_cabang` br
  ON tr.branch_id = br.branch_id
  JOIN `rakamin-kf-analytics-11.kimia_farma.kf_product` pr
  ON tr.product_id = pr.product_id
  JOIN cte1 c1
  ON tr.product_id = c1.product_id
