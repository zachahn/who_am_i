module WhoAmI
  module Function
    class ConvertExtractedClassToGatheredData
      include ProcParty

      def call(extracted_class)
        GatheredData.new(
          path: extracted_class.model_filepath,
          class_name: extracted_class.to_s,
          table_name: extracted_class.table_name,
          super_class: extracted_class.claimed_superclass,
          activerecord: extracted_class.activerecord,
          abstract_class: extracted_class.abstract_class
        )
      end
    end
  end
end
