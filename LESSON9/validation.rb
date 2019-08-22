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
    rescue RuntimeError => e
      puts e
      false
    end

    protected

    def validate!
      self.class.validates.each do |validation|
        attr = validation[:variable]
        attr_value = instance_variable_get("@#{attr}".to_sym)
        case validation[:type]
        when :presence
          presence_validation(attr_value)
        when :format
          format_validation(attr_value, validation[:format])
        when :type
          class_validation(attr_value, validation[:class])
        end
      end
    end

    private

    def presence_validation(attr)
      raise 'Empty or nil attribute value!' if attr.nil? || attr == ''
    end

    def format_validation(attr, format)
      raise "Attribute doesn't meet format" if attr !~ format
    end

    def class_validation(attr, type)
      raise 'Incorrect attribute type!' unless attr.is_a?(type)
    end
  end

end

# class Test
#   include Validation
#
#   NAME_FORMAT = /^\d{3}$/.freeze
#
#   attr_accessor :attr1, :attr2
#
#   validate :attr1, :presence
#   validate :attr1, :format, format: NAME_FORMAT
#   validate :attr1, :type, class: String
#   validate :attr2, :presence
#   validate :attr2, :type, class: Numeric
#
#
#   def initialize(attr1_val, attr2_val)
#     @attr1 = attr1_val
#     @attr2 = attr2_val
#     validate!
#   end
#
# end
#
# t1 = Test.new('765', 12)
# t1.attr1 = 'jhj'
# t1.valid?



