module MoneyTalks
  class AdyenClient

    attr_accessor :user, :password, :wsdl, :log_output, :lang

    def connection_handler
      @ws_client ||= Savon.client(
        basic_auth: [user, password],
        wsdl: wsdl,
        convert_request_keys_to: :lower_camelcase,
        pretty_print_xml: MoneyTalks::dev?,
        log: log_output
        )
    end

  end
end
