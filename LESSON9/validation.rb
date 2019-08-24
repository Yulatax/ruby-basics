module Validation

  class << self
    def included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
  end

  module ClassMethods

    attr_accessor :validates

    def validate(attr, validation_type, args = {})
      @validates ||= []
      @validates << {
        variable: attr,
        type: validation_type,
        format: args[:format],
        class: args[:class]
      }
    end
  end

  module InstanceMethods

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    protected

    def validate!
      self.class.validates.each do |validation|
        attr = validation[:variable]
        attr_value = instance_variable_get("@#{attr}".to_sym)
        send("#{validation[:type]}_validation", attr_value, validation)
      end
    end

    private

    def presence_validation(attr, args)
      raise 'Empty or nil attribute value!' if attr.nil? || attr == ''
    end

    def format_validation(attr, args)
      raise "Attribute doesn't meet format" if attr !~ args[:format]
    end

    def type_validation(attr, args)
      raise 'Incorrect attribute type!' unless attr.is_a?(args[:class])
    end
  end

end




