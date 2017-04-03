class CreateCompanyResults < ActiveRecord::Migration
  def change
    create_table :company_results do |t|
      t.date :fecha_resultado
      t.boolean :es_oficial
      t.float :cotizacion, :default => 0
      t.float :cotiz_max, :default => 0
      t.float :cotiz_min, :default => 0
      t.float :patrimonio_neto, :default => 0
      t.float :gastos_generales, :default => 0
      t.float :gastos_desarrollo, :default => 0
      t.float :ventas, :default => 0
      t.float :ebitda, :default => 0
      t.float :ebit, :default => 0
      t.float :beneficio_neto_ordinario, :default => 0
      t.float :beneficion_neto_total, :default => 0
      t.float :deuda_largo_plazo, :default => 0
      t.float :deuda_corto_plazo, :default => 0
      t.float :deuda_neta, :default => 0
      t.float :cf_explotacion, :default => 0
      t.float :cf_inversion, :default => 0
      t.float :cf_financiacion, :default => 0
      t.float :cf_neto, :default => 0
      t.float :dividendo_ordinario, :default => 0
      t.float :dividendo_extraordinario, :default => 0
      t.float :dividendo_total, :default => 0
      t.float :num_acciones, :default => 0
      t.float :bpa, :default => 0
      t.float :payout, :default => 0
      t.float :pago_dividendos, :default => 0
      t.float :per_max, :default => 0
      t.float :per_med, :default => 0
      t.float :per_min, :default => 0
      t.references :company, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
