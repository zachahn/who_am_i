module WhoAmI
  module Function
    class ExtractModelData
      using Refinement::YieldSelf
      include ProcParty

      def call(extracted_classes)
        extracted_classes
          .yield_self(&ResolveClassRelationships.new)
          .yield_self(&ResolveActiveRecord.new)
      end
    end
  end
end
