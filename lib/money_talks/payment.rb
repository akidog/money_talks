module MoneyTalks
  class Payment

    extend  Savon::Model
    include Serializable

    attr_accessor :merchant_account, :reference, :shopper_IP, :shopper_email, :shopper_reference, :fraud_offset,
      :select_brand, :authorization_code, :selected_brand, :shopper_statement, :selected_brand,
      :social_security_number, :delivery_date, :original_reference

    OPERATIONS = {
      authorise:        :payment_request,
      refund:           :modification_request,
      cancel_or_refund: :modification_request
    }

    COMPLEX_TYPES      = %w(additional_data)
    SIMPLE_TYPES       = %w(amount installments billing_address shopper_name modification_amount card)

    ['additional_data'].each do |complex_type|
      define_method complex_type do |&block|
        var = instance_variable_get("@#{complex_type}")
        if var.nil?
          field = Object.const_get("MoneyTalks::ComplexTypes::#{complex_type.camelize}").new
          field.instance_eval(&block)
          instance_variable_set("@#{complex_type}", field)
        end
        block ? block.call(instance_variable_get("@#{complex_type}")) : instance_variable_get("@#{complex_type}")
      end
    end

    SIMPLE_TYPES.each do |struct_name|
      define_method struct_name do |&block|
        var = instance_variable_get("@#{struct_name}")
        instance_variable_set("@#{struct_name}", OpenStruct.new) if var.nil?
        block ? block.call(instance_variable_get("@#{struct_name}")) : instance_variable_get("@#{struct_name}")
      end
    end

    [:authorise, :refund, :cancel_or_refund].each do |method|
      define_method method do
        begin
          response = client.connection_handler.call(method, message: self.serialize_as(OPERATIONS[method]))
          if block_given?
            yield response
          else
            response
          end
        rescue Savon::SOAPFault => error
          puts error.message
          #raise MoneyTalks::Error.new(error.message.match(/[0-9]{3}/).to_s)
        end
      end
    end

    def serialize_as(operation)
      {operation => self.to_h}
    end

    def client
      MoneyTalks::client
    end

  end
end
