module WhoAmI
  module Function
    class Ls
      include ProcParty

      def call(path)
        glob = File.expand_path(path)

        Dir[glob].select { |path| File.file?(path) }
      end
    end
  end
end
