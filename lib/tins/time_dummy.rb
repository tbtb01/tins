module Tins
  module TimeDummy
    def self.included(modul)
      modul.module_eval do
        class << self
          alias really_new new
          remove_method :now rescue nil
          remove_method :new rescue nil
        end

        extend ClassMethods
      end
    end

    module ClassMethods
      attr_writer :dummy

      def dummy(value = nil)
        if value.nil?
          @dummy
        else
          begin
            old_dummy = @dummy
            @dummy = value
            yield
          ensure
            @dummy = old_dummy
          end
        end
      end

      def new
        if dummy
          dummy.dup
        else
          really_new
        end
      end

      alias now new
    end
  end
end

require 'tins/alias'
