deploy :IMBS do

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

    create :ps, 'imbs_data_ps_new_0.des' do
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
