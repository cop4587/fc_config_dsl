deploy :IMBS do

  config :conf do

    modify :ns, 'imbs_conf_ns_0.conf' do
      upd :key_0 => 'upd 0'
    end
  end
end
