class BasicGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :attributes, type: :array, default: [], banner: 'field:type field:type'
  class_option :parent, type: :string, default: 'ApplicationRecord', desc: 'The parent class for the generated model'

  def create_model_file
    template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
  end

  def create_test_file
    template 'model_test.rb', File.join('test/models', class_path, "#{file_name}_test.rb")
  end

  def parent_class_name
    options[:parent]
  end

  private

  def parse_attributes!
    self.attributes = (attributes || []).map do |attr|
      name, type = attr.split(':')
      Rails::Generators::GeneratedAttribute.new(name, type || 'string')
    end
  end
end
