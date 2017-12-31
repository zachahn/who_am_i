module WhoAmI
  module Function
    class ConvertClasslikeToGatheredData
      include ProcParty

      def call(classlike)
        GatheredData.new(
          path: classlike.filename,
          class_name: classlike.to_s,
          table_name: classlike.table_name,
          super_class: classlike.superclass,
          activerecord: classlike.activerecord,
          abstract_class: classlike.abstract_class
        )
      end
    end
  end
end
