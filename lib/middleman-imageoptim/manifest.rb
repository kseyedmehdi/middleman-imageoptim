module Middleman
  module Imageoptim
    class Manifest
      MANIFEST_FILENAME = 'imageoptim.manifest.yml'

      attr_reader :app

      def initialize(app)
        @app = app
      end

      def path
        File.join(app.build_dir, MANIFEST_FILENAME)
      end

      def build_and_write(new_resources)
        write(dump(build(new_resources)))
      end

      def resource(key)
        resources[key.to_s]
      end

      private

      def resources
        @resources ||= load(path)
      end

      def dump(source)
        YAML.dump(source)
      end

      def load(path)
        YAML.load(File.read(path))
      end

      def build(resources)
        resources.inject({}) do |new_manifest, resource|
          new_manifest[resource.to_s] = Digest::SHA2.hexdigest(File.read(resource))
          new_manifest
        end
      end

      def write(manifest)
        File.open(path, 'w') do |manifest_file|
          manifest_file.write(manifest)
        end
      end
    end
  end
end
