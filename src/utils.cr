module Croperty
  enum Mode
    Default = 0 # mode for property, getter
    Query   = 1 # mode for property?, getter?
    Exclaim = 2 # mode for property!, getter!
  end

  annotation Property
  end

  annotation Getter
  end

  annotation Setter
  end
end
