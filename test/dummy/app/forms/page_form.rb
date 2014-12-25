class PageForm < ActiveForm::Base
  attribute :title, required: true

  association :book do
    attribute :title, :isbn, :year, required: true

    association :authors, records: 2 do
      attribute :name, required: true
      attribute :role
    end
  end
end
