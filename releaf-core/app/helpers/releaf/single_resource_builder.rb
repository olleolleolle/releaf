module Releaf::SingleResourceBuilder
  include Releaf::ViewBuilder
  attr_accessor :resource

  def initialize(template)
    super
    self.resource = template.instance_variable_get("@resource")
  end

end
