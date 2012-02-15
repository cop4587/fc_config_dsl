# conf Array

deploy :IMAS do

  config :conf do

    modify :ps, 'imas_conf_ps_0.conf' do

      # add feature.lib[2].key_0 => 'val 0'
      # add feature.lib[2].key_1 => 'val 1'
      add :feature do
        _ :lib, 2 do       # _ represents one element of an array
          _ :key_0 => 'valu 0'
          _ :key_1 => 'valu 1'
        end
      end

      # upd feature.sub_feature[0].key_1 => 'upd val'
      upd :feature do
        _ :dump_feature_body, 0 do
          _ :key_1 => 'upd val'
        end
      end

    end
  end
end

=begin OUTPUT
[feature]
feature_key_0 : val 0

[.@sub_feature]
sub_feature_0_key_0 : val 0

[..@lib]
index : 1

[..@lib]
index : 2

[..@lib]
index : 3

[.@sub_feature]
sub_feature_1_key_0 : val 0

[.@sub_feature]
sub_feature_2_key_0 : val 0

=end