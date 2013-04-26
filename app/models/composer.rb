class Composer
  def self.compose(seed, method)
    if method == :all
      Rails.logger.debug("spawing markov")
      self.compose(seed, :markov)
      Rails.logger.debug("spawing weka")
      self.compose(seed, :oner)
    else
      Spawnling.new do
        script_dir = Rails.root.join("script")
        if method == :markov
          args = seed.ordered_chords.map{|c| c.name}.join(' ')
          3.times do
            csv = `bash -c 'cd #{script_dir}; ruby compose-markov.rb #{args}'`
            csv.chomp!
            Sequence.new_from_csv(csv, method, seed)
          end
        else
          # prepare arff files
          init_file = File.join(script_dir, "init.arff")
          FileUtils.cp(File.join(script_dir, "init_header.arff"),
                       init_file)
          File.open(init_file, 'a') { |file| file.write(seed.to_csv + ",?\n") }
          `bash -c 'cd #{script_dir}; ./compose-weka'`

          Rails.logger.debug("weka done, processing arffs")
          [:j48, :randomforests, :oner].each do |model|
            Rails.logger.debug("processing #{model}_compose.arff")
            arff_name = File.join(script_dir, "#{model}_compose.arff")
            array = []
            File.open(arff_name, "r") do |file|
              Rails.logger.debug("file opened")
              line = file.gets
              until line =~ /^@DATA/ do
                line = file.gets
              end
              # skip first line, it is the seed
              line = file.gets
              while line = file.gets
                # index = number of priors - 1
                array << line.split(",")[3]
              end
            end
            Rails.logger.debug("finished processing #{model}_compose.arff, creating sequence from array: #{array.inspect}")
            Sequence.new_from_csv(array.join(","), model, seed)
          end
        end
      end
    end
  end
end
