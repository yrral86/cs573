class Composer < ActiveRecord::Base
  def self.compose(seed, model)
    Spawnling.new do
      if model == :markov
        do_magic
      else
        script_dir = Rails.root.join("script")
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
