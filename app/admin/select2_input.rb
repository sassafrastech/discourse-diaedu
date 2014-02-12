# a Formtastic input helper that generates a select2-enabled select field
module Formtastic
  module Inputs
    class Select2Input

      include Base
      include Base::Stringish

      def to_html
        input_wrapping do

          # generate and add unique ID for select tag so select2 can find it
          uid = rand(10000000000)
          options[:input_html] ||= {}
          options[:input_html][:'data-select2-id'] = uid

          # remove the :as option and run through the builder again
          # this will result in a regular multiselect, which will then get wrapped with select2
          options.delete(:as)

          # add a document.ready to setup select2 for this select
          builder.input(method, options) << template.javascript_tag("
            $(document).ready(function(){ $('select[data-select2-id=#{uid}]').select2(); });
          ")

        end
      end
    end
  end
end