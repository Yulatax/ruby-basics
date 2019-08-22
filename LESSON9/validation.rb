module Validation

  def validate(attr, validation_type, args = {})
    create_validation_methods(attr, validation_type, args)
    create_validate(attr, args)
    create_valid
  end

  def create_validation_methods(attr, validation_type, args = {})
    case validation_type
    when :presence
      define_method(:presence_validation) do |val|
        raise 'Empty or nil attribute value!' if val.nil? || val == ''
      end
    when :format
      define_method(:format_validation) do |val|
        raise "Attribute doesn't meet format" if val !~ args[:format]
      end
    when :type
      define_method(:type_validation) do |val|
        raise 'Incorrect attribute type!' unless val.is_a?(args[:class_type])
      end
    end
  end

  def create_validate(attr, args)
    define_method(:validate!) do
      attr_val = instance_variable_get("@#{attr}".to_sym)
      presence_validation(attr_val) if methods.include?(:presence_validation)
      format_validation(attr_val) if methods.include?(:format_validation)
      type_validation(attr_val) if methods.include?(:type_validation)
    end
  end

  def create_valid
    define_method(:valid?) do
      validate!
      true
    rescue RuntimeError => e
      puts e
      false
    end
  end
end

# class Test
#   extend Validation
#
#   NAME_FORMAT = /^\d{3}$/.freeze
#
#   attr_accessor :attr1
#
#   validate :attr1, :presence
#   validate :attr1, :format, format: NAME_FORMAT
#   validate :attr1, :type, class_type: Numeric
#
# end
#
# t1 = Test.new
# p t1.attr1 = '234'
# a = t1.attr1
# p t1.validate!
# p t1.valid?
# p t1.presence_validation(a)
# p t1.format_validation(a)
# p t1.type_validation(a)


