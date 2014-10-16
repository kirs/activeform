require 'test_helper'
require_relative 'required_association_form_fixture'

class RequiredAssociationFormTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests
  fixtures :conferences, :speakers, :presentations

  def setup
    @conference = Conference.new
    @form = RequiredAssociationFormFixture.new(@conference)
    @model = @form
  end

  test "main form validates itself" do
    params = {
      name: "Euruco",
      city: "Athens",

      speaker_attributes: {
        name: "Petros Markou",
        occupation: "Developer"
      }
    }

    @form.submit(params)

    assert @form.valid?
  end

  test "validates required" do
    params = {
      name: "Euruco",
      city: "Athens"
    }

    @form.submit(params)

    assert_not @form.valid?

    assert_includes @form.errors.messages[:name], "can't be blank"
    assert_includes @form.errors.messages[:occupation], "can't be blank"
  end

  test "validates not required if they are touched" do
    params = {
      name: "Euruco",
      city: "Athens",

      speaker_attributes: {
        name: "Petros Markou",
        occupation: "Developer",
        presentations_attributes: {
          "0" => { topic: nil, duration: nil },
          "1" => { topic: nil, duration: nil },
        }
      }
    }

    @form.submit(params)

    assert_not @form.valid?

    assert_includes @form.errors.messages[:topic], "can't be blank"
    assert_equal 2, @form.errors.messages[:topic].size
    assert_includes @form.errors.messages[:duration], "can't be blank"
    assert_equal 2, @form.errors.messages[:duration].size
  end
end
