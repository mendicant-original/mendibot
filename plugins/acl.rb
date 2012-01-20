module Mendibot
  module Plugins
    module Acl

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def abilities
          @abilities ||= {}
        end

        def can method, filter
          hook :pre, method: :check_ability
          method = method.to_s
          abilities[method] ||= []
          abilities[method] << filter
        end
      end

      def check_ability m
        _, command = m.params.last.match(/^!(\S+)/).to_a
        return unless self.class.abilities.keys.include?(command)
        self.class.abilities[command].each do |filter|
          send(filter, m)
        end
      end
    end
  end
end