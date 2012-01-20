module Mendibot
  module Plugins
    module ACL

      PermissionDenied = Class.new(StandardError)

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def abilities
          @abilities ||= {}
        end

        def can(method, filter)
          hook(:pre, method: :check_ability)
          method = method.to_s
          abilities[method] ||= []
          abilities[method] << filter
        end
      end

      def check_ability(message)
        command = extract_command(message)
        return unless valid_command?(command)
        filters_for(command).each do |filter|
          send(filter, message)
        end
      end

      private

      def extract_command(message)
        message.params.last.match(/^!(\S+)/).to_a.last
      end

      def valid_command?(command)
        self.class.abilities.has_key?(command)
      end

      def filters_for(command)
        self.class.abilities[command]
      end
    end
  end
end