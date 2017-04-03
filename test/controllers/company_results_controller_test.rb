require 'test_helper'

class CompanyResultsControllerTest < ActionController::TestCase
  setup do
    @company_result = company_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:company_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company_result" do
    assert_difference('CompanyResult.count') do
      post :create, company_result: { beneficio_neto_ordinario: @company_result.beneficio_neto_ordinario, beneficion_neto_total: @company_result.beneficion_neto_total, bpa: @company_result.bpa, cf_explotacion: @company_result.cf_explotacion, cf_financiacion: @company_result.cf_financiacion, cf_inversion: @company_result.cf_inversion, cf_neto: @company_result.cf_neto, company_id: @company_result.company_id, cotiz_max: @company_result.cotiz_max, cotiz_min: @company_result.cotiz_min, cotizacion: @company_result.cotizacion, deuda_corto_plazo: @company_result.deuda_corto_plazo, deuda_largo_plazo: @company_result.deuda_largo_plazo, deuda_neta: @company_result.deuda_neta, dividendo_extraordinario: @company_result.dividendo_extraordinario, dividendo_ordinario: @company_result.dividendo_ordinario, dividendo_total: @company_result.dividendo_total, ebit: @company_result.ebit, ebitda: @company_result.ebitda, es_oficial: @company_result.es_oficial, fecha_resultado: @company_result.fecha_resultado, gastos_desarrollo: @company_result.gastos_desarrollo, gastos_generales: @company_result.gastos_generales, num_acciones: @company_result.num_acciones, pago_dividendos: @company_result.pago_dividendos, patrimonio_neto: @company_result.patrimonio_neto, payout: @company_result.payout, per_max: @company_result.per_max, per_med: @company_result.per_med, per_min: @company_result.per_min, user_id: @company_result.user_id, ventas: @company_result.ventas }
    end

    assert_redirected_to company_result_path(assigns(:company_result))
  end

  test "should show company_result" do
    get :show, id: @company_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company_result
    assert_response :success
  end

  test "should update company_result" do
    patch :update, id: @company_result, company_result: { beneficio_neto_ordinario: @company_result.beneficio_neto_ordinario, beneficion_neto_total: @company_result.beneficion_neto_total, bpa: @company_result.bpa, cf_explotacion: @company_result.cf_explotacion, cf_financiacion: @company_result.cf_financiacion, cf_inversion: @company_result.cf_inversion, cf_neto: @company_result.cf_neto, company_id: @company_result.company_id, cotiz_max: @company_result.cotiz_max, cotiz_min: @company_result.cotiz_min, cotizacion: @company_result.cotizacion, deuda_corto_plazo: @company_result.deuda_corto_plazo, deuda_largo_plazo: @company_result.deuda_largo_plazo, deuda_neta: @company_result.deuda_neta, dividendo_extraordinario: @company_result.dividendo_extraordinario, dividendo_ordinario: @company_result.dividendo_ordinario, dividendo_total: @company_result.dividendo_total, ebit: @company_result.ebit, ebitda: @company_result.ebitda, es_oficial: @company_result.es_oficial, fecha_resultado: @company_result.fecha_resultado, gastos_desarrollo: @company_result.gastos_desarrollo, gastos_generales: @company_result.gastos_generales, num_acciones: @company_result.num_acciones, pago_dividendos: @company_result.pago_dividendos, patrimonio_neto: @company_result.patrimonio_neto, payout: @company_result.payout, per_max: @company_result.per_max, per_med: @company_result.per_med, per_min: @company_result.per_min, user_id: @company_result.user_id, ventas: @company_result.ventas }
    assert_redirected_to company_result_path(assigns(:company_result))
  end

  test "should destroy company_result" do
    assert_difference('CompanyResult.count', -1) do
      delete :destroy, id: @company_result
    end

    assert_redirected_to company_results_path
  end
end
