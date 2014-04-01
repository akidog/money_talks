module MoneyTalks
  module Payable

    def authorize!
      begin
        adapter.authorize_payment(self)
      rescue
        Callbacks.included
      end
    end

    def cancel(callbacks={}, &data)      
      adapter.cancel_payment(callbacks, &data)
    end

    def refund(callbacks={}, &data)
      adapter.refund_payment(callbacks, &data)
    end

    def capture(callbacks={}, &data)
      adapter.capture_payment(callbacks, &data)
    end

    private

    def adapter
      MoneyTalks::adapter
    end
  
  end
end
