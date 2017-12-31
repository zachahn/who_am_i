module WhoAmI
  module Function
    class ComputeContent
      include ProcParty

      PATTERN = %r{\A(?:(?:^#.*?$)\n)*\n*(.*)}m

      def call(gathered_data)
        original_content = File.read(gathered_data.path)
        content = PATTERN.match(original_content)
        gathered_data.computed_content = content
      end
    end
  end
end
