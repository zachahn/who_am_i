module WhoAmI
  module Function
    class AnnotateModels
      using Refinement::YieldSelf
      include ProcParty

      def initialize(config, tables)
        @config = config
        @tables = tables
      end

      def call
        paths
          .flat_map(&Ls.new)
          .flat_map(&ParseModel.new)
          .tap(&ExtractModelData.new)
          .select(&:activerecord?)
          .reject(&:abstract_class?)
          .yield_self(&ResolveTables.new)
          .each(&ComputeComment.new)
          .each(&ComputeContent.new)
          .each(&WriteModel.new)
      end

      private

      def paths
        if @config.nil?
          []
        else
          @config[:paths]
        end
      end
    end
  end
end
