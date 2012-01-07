modify :ns, 'data_ns.des' do

  del 'entry_0'
  
  upd 'entry_1' do
    _ key_10: 'upd 10'
    _ key_11: 'upd 11'
  end
  
  add 'entry_2' do
    _ key_20: 'add 20'
    _ key_21: 'add 21'
  end  
end

create :ps, 'data_ps.des' do
  add 'entry_0' do
    _ key_00: 'new 00'
    _ key_01: 'new 01'
  end

  add 'entry_1' do
    _ key_10: 'new 10'
    _ key_11: 'new 11'
  end
end

modify :ns, 'data_ns.des' do
  add 'entry_3' do
    _ key_30: 'add 30'
    _ key_31: 'add 31'
  end
end

