deploy :IMAS do

  config :conf do

    modify :ps, 'imas_conf_ns_0.conf' do
      add :feature_0 => 'feature 0'
    end
  end
end