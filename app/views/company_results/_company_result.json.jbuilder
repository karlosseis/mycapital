json.extract! company_result, :id, :fecha_resultado, :es_oficial, :cotizacion, :cotiz_max, :cotiz_min, :patrimonio_neto, :gastos_generales, :gastos_desarrollo, :ventas, :ebitda, :ebit, :beneficio_neto_ordinario, :beneficion_neto_total, :deuda_largo_plazo, :deuda_corto_plazo, :deuda_neta, :cf_explotacion, :cf_inversion, :cf_financiacion, :cf_neto, :dividendo_ordinario, :dividendo_extraordinario, :dividendo_total, :num_acciones, :bpa, :payout, :pago_dividendos, :per_max, :per_med, :per_min, :company_id, :user_id, :created_at, :updated_at
json.url company_result_url(company_result, format: :json)