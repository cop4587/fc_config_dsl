modify :ns, 'data.des' do

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

