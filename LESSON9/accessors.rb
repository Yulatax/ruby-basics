module Accessors

  def attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      attr_name = "@#{attr}".to_sym
      attr_values_var = "@#{attr}_values".to_sym

      define_method(attr) do
        instance_variable_get(attr_name)
      end

      define_method("#{attr}=".to_sym) do |val|
        instance_variable_set(attr_name, val)
        instance_variable_set(attr_values_var, []) if
          instance_variable_get(attr_values_var).nil?
        history = instance_variable_get(attr_values_var)
        history << val
      end

      define_method("#{attr}_history") { instance_variable_get(attr_values_var) }

    end
  end

  def strong_attr_accessor(attr, type)
    attr_name = "@#{attr}".to_sym

    define_method(attr) do
      instance_variable_get(attr_name)
    end

    define_method("#{attr}=".to_sym) do |val|
      raise TypeError.new("Incorrect attribute type!") unless val.is_a?(type)
      instance_variable_set(attr_name, val)
    end
  end

end

# class Test
#   extend Accessors
#   attr_accessor_with_history :attr1, :attr2
#   strong_attr_accessor :attr3, String
#   strong_attr_accessor :attr4, Array
# end
#
# t1 = Test.new
# t1.attr1 = 1
# t1.attr1 = 5
# p t1.attr3 = 'Hello'
# p t1.attr1_history
# p t1.instance_variables
#
# t2 = Test.new
# t2.attr1 = 11
# t2.attr2 = 2
# t2.attr2 = 7
# p t2.attr1_history
# p t2.attr2_history
# p t2.instance_variables
# p t2.attr4 = %w[h e l l o]
