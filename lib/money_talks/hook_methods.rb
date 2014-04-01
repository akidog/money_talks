module MoneyTalks
  module HookMethods
    
    def on_post_back(method=nil, &callback)
      @hook = method || callback
    end

    def registered_hook
      @hook
    end

  end
end
