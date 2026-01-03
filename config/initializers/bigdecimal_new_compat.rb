# Compatibilidad: algunas versiones antiguas de código/gemas usan BigDecimal.new(...)
# En versiones modernas de BigDecimal ya no existe.
require "bigdecimal"

class BigDecimal
  def self.new(*args)
    BigDecimal(*args)
  end
end
