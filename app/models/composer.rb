class Composer < ActiveRecord::Base
  def self.compose(seed, model)
    if model == :all
      logger.debug("spawing markov")
      self.compose(seed, :markov)
      logger.debug("spawing j48")
      self.compose(seed, :j48)
      logger.debug("spawing randomforests")
      self.compose(seed, :randomforests)
      logger.debug("spawing oner")
      self.compose(seed, :oner)
    else
      Spawnling.new do
        script_dir = Rails.root.join("script")
        if model == :markov
          args = seed.ordered_chords.map{|c| c.name}.join(' ')
          3.times do
            csv = `bash -c 'cd #{script_dir}; ruby compose-markov.rb #{args}'`
            csv.chomp!
            Sequence.new_from_csv(csv, model, seed)
          end
        else
          # prepare arff files
          init_file = File.join(script_dir, "init.arff")
          FileUtils.cp(File.join(script_dir, "init_header.arff"),
                       init_file)
          File.open(init_file, 'a') { |file| file.write(seed.to_csv + ",?\n") }
          arff_name = "_compose.arff"
          if model == :j48
            `bash -c 'cd #{script_dir}; ./compose-j48'`
            arff_name = File.join(script_dir, "j48#{arff_name}")
          elsif model == :randomforests
            `bash -c 'cd #{script_dir}; ./compose-randomforests'`
            arff_name = File.join(script_dir, "randomforest#{arff_name}")
          elsif model == :oner
            `bash -c 'cd #{script_dir}; ./compose-oner'`
            arff_name = File.join(script_dir, "oner#{arff_name}")
          end
          array = []
          File.open(arff_name, "r") do |file|
            line = file.gets
            until line =~ /^@DATA/ do
              line = file.gets
            end
            line = file.gets
            while line = file.gets
              array << line.split(",")[2]
            end
          end
          Sequence.new_from_csv(array.join(","), model, seed)
        end
      end
    end
  end
end
