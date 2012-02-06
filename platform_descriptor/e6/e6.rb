# IMAS + feature
deploy :IMAS do

  config :conf do

    require '../feature/imas/conf/rb23'

    modify :ps, 'imas_conf_ns_0.conf' do
      upd :key_0 => 'upd 0'
      upd :key_1 => 'upd 1'
    end
  end
end

