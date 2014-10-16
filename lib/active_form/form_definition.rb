module ActiveForm
  class FormDefinition
    attr_accessor :assoc_name, :proc, :parent, :records, :required

    def initialize(assoc_name, block, options={})
      @assoc_name = assoc_name
      @proc = block
      @records = options[:records]
      @required = options[:required]
    end

    def to_form
      macro = association_reflection.macro

      case macro
      when :has_one, :belongs_to
        form = Form.new(assoc_name, parent, proc, nil, { required: required })
        form.instance_eval &proc
        form
      when :has_many
        FormCollection.new(assoc_name, parent, proc, { records: records, required: required })
      end
    end

    private

    def association_reflection
      parent.class.reflect_on_association(@assoc_name)
    end
  end

end
