require "yaml"

describe "output/e4/" do

  OUTPUT_ROOT = 'output/e4'

  context "imas/" do
    context "bin/" do

      it "imas_bin_ps_0.des" do
        file = "#{OUTPUT_ROOT}/imas/bin/imas_bin_ps_0.des"
        output_content = YAML.load_file File.open(file)

        output_content['imas_bin_entry_0']['key_0'].should == '0.0'.to_f
        output_content['imas_bin_entry_0']['key_1'].should == '0.1'.to_f

        output_content['imas_bin_entry_1']['key_0'].should == 'upd 10'
        output_content['imas_bin_entry_1']['key_1'].should == 'upd 11'

        output_content['imas_bin_entry_2']['key_0'].should == '20'.to_f
        output_content['imas_bin_entry_2']['key_1'].should == '21'.to_f
      end
    end

    context "conf/" do
      it "imas_conf_ps_0.conf" do
        file = "#{OUTPUT_ROOT}/imas/conf/imas_conf_ps_0.conf"
        output_content = YAML.load_file File.open(file)

        output_content['imas_conf_key_0'].should == nil
        output_content['imas_conf_key_1'].should == 'upd 1'
        output_content['imas_conf_key_2'].should == 'upd 2'
        output_content['imas_conf_key_3'].should == 'new 3'
      end
    end
  end

  context "imbs/" do
    context "conf/" do
      it "imbs_conf_ns_0.conf" do
        file = "#{OUTPUT_ROOT}/imbs/conf/imbs_conf_ns_0.conf"
        output_content = YAML.load_file File.open(file)

        output_content['key_0'].should == nil
        output_content['key_1'].should == 'upd 1'
        output_content['key_2'].should == '2'.to_f
        output_content['key_3'].should == 'add 3'
      end

      it "imbs_conf_ns_1.conf" do
        file = "#{OUTPUT_ROOT}/imbs/conf/imbs_conf_ns_1.conf"
        output_content = YAML.load_file File.open(file)

        output_content['key_0'].should == 'new 0'
        output_content['key_1'].should == 'new 1'
      end
    end

    context "data/" do
      it "imbs_data_ns_0.des" do
        file = "#{OUTPUT_ROOT}/imbs/data/imbs_data_ns_0.des"
        output_content = YAML.load_file File.open(file)

        output_content['entry_0'].should == nil

        output_content['entry_1']['key_10'].should == 'upd 10'

        output_content['entry_2']['key_20'].should == 'add 20'
        output_content['entry_2']['key_21'].should == 'add 21'

        output_content['entry_3']['key_30'].should == 'add 30'
        output_content['entry_3']['key_31'].should == 'add 31'
      end

      it "imbs_data_ps_0.des" do
        file = "#{OUTPUT_ROOT}/imbs/data/imbs_data_ps_0.des"
        output_content = YAML.load_file File.open(file)

        output_content['entry_0']['key_00'].should == 'new 00'
        output_content['entry_0']['key_01'].should == 'new 01'

        output_content['entry_1']['key_10'].should == 'new 10'
        output_content['entry_1']['key_11'].should == 'new 11'
      end
    end
  end
end