module LiveUnit
  ##
  #loads all the required test files when the <evaluate_me> method is called
  class Loader
    ##
    #extracted from require_directory gem
    def require_directory(dir, add_to_load_path = false, skip_invalid_syntax = false)
      raise "Not a directory: #{dir}" unless File.directory?(dir)
      if add_to_load_path
        $LOAD_PATH << dir
      end
      Dir.glob(File.join(dir + '/**/*.rb')).each do |file|
        if (skip_invalid_syntax && !(`/usr/bin/env ruby -c #{file}` =~ /Syntax OK/m))
          warn "Invalid syntax in: #{file}"
          next
        end
        require file
      end
    end
  end
end
