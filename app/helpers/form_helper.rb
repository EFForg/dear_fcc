module DearFcc
  class App
    module FormHelper
      def write_dear_fcc_comment
        comment_elements.each_with_index.map do |element, i|
          name = "comment[element_#{i}]"

          case element["type"]
          when "select-or-other"
            other_name = "comment[element_#{i}_other]"
            choices = element["choices"].map{ |opt| [opt, opt] } << ["Other..", "other"]

            content_tag(:fieldset, class: "select-or-other") do
              label_tag(name, caption: nil){ element["prefix"] } +
                select_tag(name, options: choices, class: "form-control") +
                content_tag(:div, class: "other"){ text_field_tag(other_name, class: "form-control") }
            end

          when "freeform"
            content_tag(:fieldset) do
              label_tag(name, caption: nil){ element["prompt"] } +
                text_area_tag(name, value: element["placeholder"], class: "form-control", rows: 5)
            end
          end
        end.join.html_safe
      end

      def read_dear_fcc_comment(params)
        comment = ""

        comment_elements.each_with_index do |element, i|
          name = "element_#{i}"

          case element["type"]
          when "select-or-other"
            if params[name] == "other"
              comment << " " + [element["prefix"], params.fetch("#{name}_other").strip].join(" ")
            else
              comment << " " + [element["prefix"], params.fetch(name).strip].join(" ")
            end

          when "freeform"
            comment << " " + params.fetch(name).strip
          end
        end

        comment.strip
      end

      def estimate_textarea_rows(comment)
        (comment.size / 70.0).round
      end

      private

      def comment_elements
        YAML.load_file("#{Padrino.root}/config/comment-elements.yml")
      end
    end

    helpers FormHelper
  end
end
