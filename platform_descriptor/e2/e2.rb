deploy :IMBS do

  config :conf do

    modify :ns, 'imbs_conf_ns_0.conf' do
      del :key_0
      upd :key_1 => 'upd 1'
      add :key_3 => 'add 3'
    end
  end
end
