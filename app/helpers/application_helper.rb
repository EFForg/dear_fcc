module DearFcc
  class App
    module ApplicationHelper
      def comment_period_open?
        proceedings.first.key?("deadline") && Time.now < proceedings.first.fetch("deadline")
      end

      private

      def proceedings
        if Padrino.env == :production
          $proceedings ||= YAML.load_file("#{Padrino.root}/config/proceedings.yml")
        else
          YAML.load_file("#{Padrino.root}/config/proceedings.yml")
        end
      end
    end

    helpers ApplicationHelper
  end
end
