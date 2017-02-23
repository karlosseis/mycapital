module OperationsHelper

  def render_operation_conditionally
    case @operation.operationtype_id
    when Mycapital::OP_DIVIDEND
       render :partial => 'form_dividend'
    when Mycapital::OP_SALE
       render :partial => 'form_sale'
    when Mycapital::OP_PURCHASE
       render :partial => 'form_purchase'     
    else
       render :partial => 'form_ampliation'
    end
  end


end

