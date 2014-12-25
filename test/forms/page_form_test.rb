require 'test_helper'

class PageFormTest < ActiveSupport::TestCase
  # include ActiveModel::Lint::Tests
  include ActionDispatch::TestProcess

  fixtures :books, :authors

  def setup
    @page = Page.new
    @page.book = Book.new

    @form = PageForm.new(@page)
    # @model = @form
  end

  test "main form syncs its model and the models in nested sub-forms" do
    @form.submit(default_params)

    assert_equal @form.book.model.object_id, @page.book.object_id
    assert_equal @form.model.object_id, @page.object_id

    assert_equal "page title", @form.title
    assert_equal "page title", @page.title

    assert_equal "Programming Ruby 1.9 & 2.0", @form.book.title
    assert_equal "Programming Ruby 1.9 & 2.0", @page.book.title

    assert_equal 2014, @form.book.year
    assert_equal 2014, @page.book.year

    assert_difference 'Author.count', 2 do
      @form.save
    end

    # end

    # assert_equal "Chad Fowler", @form.book.authors[0].name
    # assert_equal "Chad Fowler", @page.book.authors[0].name

    # assert_equal "1st author", @form.book.authors[0].role
    # assert_equal "1st author", @page.book.authors[0].role

    # assert_equal "Dave Thomas", @form.book.authors[1].name
    # assert_equal "Dave Thomas", @page.book.authors[1].name

    # assert_equal "2nd author", @form.book.authors[1].role
    # assert_equal "2nd author", @page.book.authors[1].role

    # # @form.save

    assert_equal 2, @page.book.authors.size
    assert_equal 2, @form.book.authors.size
  end

  # test "main form syncs its model and the models in nested sub-forms with dynamic key" do
  #   skip
  #   @form.submit(merge_params({
  #     book_attributes: {
  #       authors_attributes: {
  #         "0" => { name: "Chad Fowler", role: "1st author" },
  #         "1" => { name: "Dave Thomas", role: "2nd author" },
  #         "1404292088779" => { name: "Kir Shatrov", role: "dev" },
  #       }
  #     }
  #   }))

  #   assert_equal default_params[:title], @form.title
  #   assert_equal default_params[:book_attributes][:year].to_i, @form.book.year
  #   # assert_equal default_params[:authors_attributes]["0"][:name], @form.authors[0].name
  #   # assert_equal default_params[:authors_attributes]["0"][:role], @form.authors[0].role

  #   # assert_equal default_params[:authors_attributes]["1"][:name], @form.authors[1].name
  #   # assert_equal default_params[:authors_attributes]["1"][:role], @form.authors[1].role

  #   # raise @form.book.authors.size.inspect
  #   assert_equal 3, @form.book.authors.size
  # end

  # test "contains getter for presentations sub-form" do
  #   assert_respond_to @form.speaker, :presentations

  #   author_form = @form.speaker.forms.first
  #   assert_instance_of ActiveForm::FormCollection, author_form
  # end

  # test "#represents? returns true if the argument matches the Form's association name, false otherwise" do
  #   presentations_form = @form.speaker.forms.first

  #   assert presentations_form.represents?("presentations")
  #   assert_not presentations_form.represents?("presentation")
  # end

  # test "main form provides getter method for collection objects" do
  #   assert_respond_to @form.speaker, :presentations

  #   presentations = @form.speaker.presentations

  #   presentations.each do |form|
  #     assert_instance_of ActiveForm::Form, form
  #     assert_instance_of Presentation, form.model
  #   end
  # end

  # test "presentations sub-form contains association name and parent model" do
  #   presentations_form = @form.speaker.forms.first

  #   assert_equal :presentations, presentations_form.association_name
  #   assert_equal 2, presentations_form.records
  #   assert_equal @form.speaker.model, presentations_form.parent
  # end

  # test "presentations sub-form initializes the number of records specified" do
  #   presentations_form = @form.speaker.forms.first

  #   assert_respond_to presentations_form, :models
  #   assert_equal 2, presentations_form.models.size

  #   presentations_form.each do |form|
  #     assert_instance_of ActiveForm::Form, form
  #     assert_instance_of Presentation, form.model

  #     assert_respond_to form, :topic
  #     assert_respond_to form, :topic=
  #     assert_respond_to form, :duration
  #     assert_respond_to form, :duration=
  #   end

  #   assert_equal 2, @form.speaker.model.presentations.size
  # end

  # test "presentations sub-form fetches parent and association objects" do
  #   conference = conferences(:ruby)

  #   form = ConferenceForm.new(conference)

  #   assert_equal conference.name, form.name
  #   assert_equal 2, form.speaker.presentations.size
  #   assert_equal conference.speaker.presentations[0], form.speaker.presentations[0].model
  #   assert_equal conference.speaker.presentations[1], form.speaker.presentations[1].model
  # end


  # test "main form validates itself" do
  #   @form.submit(merge_params(speaker_attributes: { name: 'Unique Name' }))
  #   assert @form.valid?
  # end

  # test "validation with empty params" do
  #   @form.submit({})

  #   assert_not @form.valid?

  #   assert_includes @form.errors[:name], "can't be blank"
  #   assert_equal 1, @form.errors[:name].size
  #   assert_includes @form.errors[:city], "can't be blank"
  #   assert_equal 1, @form.errors[:city].size

  #   assert_includes @form.errors["speaker.name"], "can't be blank"

  #   assert_includes @form.errors["speaker.occupation"], "can't be blank"

  #   assert_includes @form.errors["speaker.presentations.topic"], "can't be blank"
  #   assert_equal 2, @form.errors["speaker.presentations.topic"].size

  #   assert_includes @form.errors["speaker.presentations.duration"], "can't be blank"
  #   assert_equal 2, @form.errors["speaker.presentations.duration"].size
  # end

  # test "main form validates the models" do
  #   @form.submit(speaker_attributes: { name: conferences(:ruby).speaker.name })

  #   assert_not @form.valid?

  #   assert_includes @form.errors["name"], "can't be blank"
  #   assert_includes @form.errors["speaker.name"], "has already been taken"
  # end

  # test "presentations sub-form raises error if records exceed the allowed number" do
  #   params = {
  #     name: "Euruco",
  #     city: "Athens",

  #     speaker_attributes: {
  #       name: "Petros Markou",
  #       occupation: "Developer",

  #       presentations_attributes: {
  #         "0" => { topic: "Ruby OOP", duration: "1h" },
  #         "1" => { topic: "Ruby Closures", duration: "1h" },
  #         "2" => { topic: "Ruby Blocks", duration: "1h" },
  #       }
  #     }
  #   }

  #   #exception = assert_raises(TooManyRecords) { @form.submit(params) }
  #   #assert_equal "Maximum 2 records are allowed. Got 3 records instead.", exception.message
  # end

  # test "main form saves its model and the models in nested sub-forms" do
  #   skip
  #   @form.submit(default_params)

  #   assert_difference('Book.count', 1) do
  #     assert_difference('Author.count', 2) do
  #       @form.save
  #     end
  #   end

  #   assert_equal default_params[:title], @form.title
  #   assert_equal default_params[:year].to_i, @form.year
  #   assert_equal default_params[:authors_attributes]["0"][:name], @form.authors[0].name
  #   assert_equal default_params[:authors_attributes]["0"][:role], @form.authors[0].role

  #   assert_equal default_params[:authors_attributes]["1"][:name], @form.authors[1].name
  #   assert_equal default_params[:authors_attributes]["1"][:role], @form.authors[1].role

  #   assert @form.persisted?
  #   assert @form.authors[0].persisted?
  #   assert @form.authors[1].persisted?
  # end

  # test "main form saves its model and dynamically added models in nested sub-forms" do
  #   @form.submit(merge_params(speaker_attributes: {
  #     name: "Petros Markou",
  #     presentations_attributes: {
  #       "1404292088779" => { topic: "Ruby Blocks", duration: "1h" }
  #     }
  #   }))

  #   assert_difference(['Conference.count', 'Speaker.count']) do
  #     @form.save
  #   end

  #   assert_equal "Euruco", @form.name
  #   assert_equal "Athens", @form.city
  #   assert_equal "Petros Markou", @form.speaker.name
  #   assert_equal "Developer", @form.speaker.occupation
  #   assert_equal "Ruby OOP", @form.speaker.presentations[0].topic
  #   assert_equal "1h", @form.speaker.presentations[0].duration
  #   assert_equal "Ruby Closures", @form.speaker.presentations[1].topic
  #   assert_equal "1h", @form.speaker.presentations[1].duration
  #   assert_equal "Ruby Blocks", @form.speaker.presentations[2].topic
  #   assert_equal "1h", @form.speaker.presentations[2].duration
  #   assert_equal 3, @form.speaker.presentations.size

  #   assert @form.persisted?
  #   assert @form.speaker.persisted?
  #   @form.speaker.presentations.each do |presentation|
  #     assert presentation.persisted?
  #   end
  # end

  # test "main form updates its model and the models in nested sub-forms" do
  #   conference = conferences(:ruby)
  #   form = ConferenceForm.new(conference)
  #   form.submit(merge_params(
  #     speaker_attributes: {
  #       presentations_attributes: {
  #         "0" => { topic: "Rails OOP", duration: "1h", id: presentations(:ruby_oop).id },
  #         "1" => { topic: "Rails Patterns", duration: "1h", id: presentations(:ruby_closures).id }
  #       }
  #     }
  #   ))

  #   assert_difference(['Conference.count', 'Speaker.count', 'Presentation.count'], 0) do
  #     form.save
  #   end

  #   assert_equal "Euruco", form.name
  #   assert_equal "Athens", form.city
  #   assert_equal "Peter Markou", form.speaker.name
  #   assert_equal "Developer", form.speaker.occupation
  #   assert_equal "Rails Patterns", form.speaker.presentations[0].topic
  #   assert_equal "1h", form.speaker.presentations[0].duration
  #   assert_equal "Rails OOP", form.speaker.presentations[1].topic
  #   assert_equal "1h", form.speaker.presentations[1].duration
  #   assert_equal 2, form.speaker.presentations.size

  #   assert form.persisted?
  # end

  # test "main form updates its model and saves dynamically added models in nested sub-forms" do
  #   conference = conferences(:ruby)
  #   form = ConferenceForm.new(conference)
  #   form.submit(merge_params(
  #     speaker_attributes: {
  #       presentations_attributes: {
  #         "0" => { topic: "Rails OOP", duration: "1h", id: presentations(:ruby_oop).id },
  #         "1" => { topic: "Rails Patterns", duration: "1h", id: presentations(:ruby_closures).id },
  #         "1404292088779" => { topic: "Rails Migrations", duration: "1h" }
  #       }
  #     }
  #   ))

  #   assert_difference(['Conference.count', 'Speaker.count'], 0) do
  #     form.save
  #   end

  #   assert_equal "Euruco", form.name
  #   assert_equal "Athens", form.city
  #   assert_equal "Peter Markou", form.speaker.name
  #   assert_equal "Developer", form.speaker.occupation
  #   assert_equal "Rails Patterns", form.speaker.presentations[0].topic
  #   assert_equal "1h", form.speaker.presentations[0].duration
  #   assert_equal "Rails OOP", form.speaker.presentations[1].topic
  #   assert_equal "1h", form.speaker.presentations[1].duration
  #   assert_equal "Rails Migrations", form.speaker.presentations[2].topic
  #   assert_equal "1h", form.speaker.presentations[2].duration
  #   assert_equal 3, form.speaker.presentations.size

  #   assert form.persisted?
  # end

  # test "main form deletes models in nested sub-forms" do
  #   skip
  #   book = books(:first)

  #   authors(:korol).books << book
  #   authors(:matz).books << book

  #   form = PageForm.new(book)
  #   form.submit(merge_params(
  #     authors_attributes: {
  #       "0" => { name: "Updated Korol", id: authors(:korol).id, "_destroy" => "1" },
  #       "1" => { name: "Updated Matz", id: authors(:matz).id }
  #     }
  #   ))

  #   assert book.authors[0].marked_for_destruction?

  #   assert_equal 1, form.authors.size

  #   assert form.persisted?
  #   form.authors.each do |presentation|
  #     assert presentation.persisted?
  #   end
  # end

  # test "main form deletes and adds models in nested sub-forms" do
  #   conference = conferences(:ruby)
  #   form = ConferenceForm.new(conference)
  #   form.submit(merge_params(
  #     speaker_attributes: {
  #       presentations_attributes: {
  #         "0" => { topic: "Rails OOP", duration: "1h", id: presentations(:ruby_oop).id, "_destroy" => "1" },
  #         "1" => { topic: "Rails Patterns", duration: "1h", id: presentations(:ruby_closures).id },
  #         "1404292088779" => { topic: "Rails Testing", duration: "2h" }
  #       }
  #     }
  #   ))

  #   assert_difference(['Conference.count', 'Speaker.count'], 0) do
  #     form.save
  #   end

  #   assert_equal "Euruco", form.name
  #   assert_equal "Athens", form.city
  #   assert_equal "Peter Markou", form.speaker.name
  #   assert_equal "Developer", form.speaker.occupation
  #   assert_equal "Rails Patterns", form.speaker.presentations[0].topic
  #   assert_equal "1h", form.speaker.presentations[0].duration
  #   assert_equal "Rails Testing", form.speaker.presentations[1].topic
  #   assert_equal "2h", form.speaker.presentations[1].duration
  #   assert_equal 2, form.speaker.presentations.size

  #   assert form.persisted?
  #   form.speaker.presentations.each do |presentation|
  #     assert presentation.persisted?
  #   end
  # end

  # test "main form responds to writer method" do
  #   assert_respond_to @form, :speaker_attributes=
  # end

  # test "speaker sub-form responds to writer method" do
  #   assert_respond_to @form.speaker, :presentations_attributes=
  # end


  private
    def merge_params(params)
      default_params.deep_merge(params)
    end

    def default_params
      @default_params ||= {
        title: "page title",
        book_attributes: {
          title: "Programming Ruby 1.9 & 2.0",
          year: "2014",
          isbn: "foobar",
          authors_attributes: {
            "0" => { name: "Chad Fowler", role: "1st author" },
            "1" => { name: "Dave Thomas", role: "2nd author" },
          }
        }
      }
    end
end
