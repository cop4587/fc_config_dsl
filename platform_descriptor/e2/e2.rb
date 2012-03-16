# IMBS conf
deploy :IMBS do

  config :conf do

    modify :ns, 'imbs_conf_ns_0.conf' do
      del :key_2
      upd :key_1 => 'upd 1'
      add :key_3 => 'add 3'
    end

    create :ns, 'imbs_conf_ns_1.conf' do
      add :key_0 => 'new 0'
      add :key_1 => 'new 1'
    end

    modify :ns, 'imbs_conf_ns_0.conf' do
      upd :key_2 => 'upd 2'
      add :key_4 => 'add 4'
    end

    modify :ns, 'imbs_conf_ns_0.gflags' do
      del :flag_0
      upd :flag_1 => 'yes'
      add :new_flag_0 => 'yes'
      add :new_flag_1 => 'no'
    end

    create :ns, 'imbs_conf_ns_1.gflags' do
      add :create_flag_0 => 'yes'
      add :create_flag_1 => 'no'
    end
  end
end
