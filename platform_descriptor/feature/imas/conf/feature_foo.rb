deploy :IMAS do

  config :conf do

    modify :ps, 'imas_conf_ns_0.conf' do
      add :foo => 'conf of feature foo'
    end
  end
end