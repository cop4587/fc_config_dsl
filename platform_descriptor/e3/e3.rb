
# e3 = e1 + e2: IMBS conf + data

deploy :IMBS do

  config :conf do

    modify :ns, 'imbs_conf_ns_0.conf' do
      del :key_0
      upd :key_1 => 'upd 1'
      add :key_3 => 'add 3'
    end

    create :ns, 'imbs_conf_ns_1.conf' do
      add :key_0 => 'new 0'
      add :key_1 => 'new 1'
    end
  end

  config :data do

    modify :ns, 'imbs_data_ns_0.des' do

      del :entry_0

      upd :entry_1 do
        _ :key_10 => 'upd 10'
      end

      add :entry_2 do
        _ :key_20 => 'add 20'
        _ :key_21 => 'add 21'
      end
    end

    create :ps, 'imbs_data_ps_0.des' do
      add :entry_0 do
        _ :key_00 => 'new 00'
        _ :key_01 => 'new 01'
      end

      add :entry_1 do
        _ :key_10 => 'new 10'
        _ :key_11 => 'new 11'
      end
    end

    modify :ns, 'imbs_data_ns_0.des' do
      add :entry_3 do
        _ :key_30 => 'add 30'
        _ :key_31 => 'add 31'
      end
    end
  end
end
